//
//  Created by Christopher Garrett on 7/17/08.
//  Copyright ZWorkbench, Inc. 2008. All rights reserved.
//


#include <AudioToolbox/AudioToolbox.h>
#import "AudioQueueObject.h"
#import "AudioPlayer.h"
#include "AudioQueueObjectDelegate.h"


static void playbackCallback (
	void					*inUserData,
	AudioQueueRef			inAudioQueue,
	AudioQueueBufferRef		bufferReference
) {
	// This callback, being outside the implementation block, needs a reference to the AudioPlayer object
	AudioPlayer *player = (AudioPlayer *) inUserData;
	if ([player donePlayingFile]) return;
		
	UInt32 numBytes;
	UInt32 numPackets = [player numPacketsToRead];

	// This callback is called when the playback audio queue object has an audio queue buffer
	// available for filling with more data from the file being played
	AudioFileReadPackets (
		[player audioFileID],
		NO,
		&numBytes,
		[player packetDescriptions],
		[player startingPacketNumber],
		&numPackets, 
		bufferReference->mAudioData
	);
		
	if (numPackets > 0) {

		bufferReference->mAudioDataByteSize = numBytes;		

		AudioQueueEnqueueBuffer (
			inAudioQueue,
			bufferReference,
			([player packetDescriptions] ? numPackets : 0),
			[player packetDescriptions]
		);
		
		[player incrementStartingPacketNumberBy: (UInt32) numPackets];
		
	} else {
	
		[player setDonePlayingFile: YES];		// 'donePlayingFile' used by playbackCallback and setupAudioQueueBuffers

		// if playback is stopping because file is finished, then call AudioQueueStop here
		// if user clicked Stop, then the AudioViewController calls AudioQueueStop
		if (player.audioPlayerShouldStopImmediately == NO) {
			[player stop];
		}

	}
}

// property callback function, invoked when a property changes. 
static void propertyListenerCallback (
	void					*inUserData,
	AudioQueueRef			queueObject,
	AudioQueuePropertyID	propertyID
) {
	// This callback, being outside the implementation block, needs a reference to the AudioPlayer object
   AudioPlayer *player = (AudioPlayer *) inUserData;
   if (player.delegate) {
      [player.delegate audioQueueStateChanged: player];      
   }
}


@implementation AudioPlayer

@synthesize packetDescriptions;
@synthesize bufferByteSize;
@synthesize gain;
@synthesize numPacketsToRead;
@synthesize donePlayingFile;
@synthesize audioPlayerShouldStopImmediately;


- (id) initWithFileName: (NSString *)fileName {
   NSString *extension = [fileName pathExtension];
   NSString *firstPart = [fileName substringToIndex: [fileName length] - [extension length] - 1];
   NSString *path = [[NSBundle mainBundle] pathForResource: firstPart ofType: extension inDirectory: nil];
   return [self initWithURL: [NSURL fileURLWithPath: path]];
}

- (id) initWithURL: (NSURL *) soundFile {

	self = [super init];

   //	set the audio session category
   UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
   AudioSessionSetProperty (
                            kAudioSessionProperty_AudioCategory,
                            sizeof (sessionCategory),
                            &sessionCategory
                            );
   
	if (self != nil) {

		self.audioFileURL =  soundFile;
		[self openPlaybackFile: self.audioFileURL];
		[self setupPlaybackAudioQueueObject];
		[self setDonePlayingFile: NO];
		[self setAudioPlayerShouldStopImmediately: YES];
	}

	return self;
} 

// magic cookies are not used by linear PCM audio. this method is included here
//	so this app still works if you change the recording format to one that uses
//	magic cookies.
- (void) copyMagicCookieToQueue: (AudioQueueRef) queue fromFile: (AudioFileID) file {

	UInt32 propertySize = sizeof (UInt32);
	
	OSStatus result = AudioFileGetPropertyInfo (
							file,
							kAudioFilePropertyMagicCookieData,
							&propertySize,
							NULL
						);

	if (!result && propertySize) {
	
		char *cookie = (char *) malloc (propertySize);		
		
		AudioFileGetProperty (
			file,
			kAudioFilePropertyMagicCookieData,
			&propertySize,
			cookie
		);
			
		AudioQueueSetProperty (
			queue,
			kAudioQueueProperty_MagicCookie,
			cookie,
			propertySize
		);
			
		free (cookie);
	}
}

- (void) openPlaybackFile: (NSURL *) soundFile {

   OSStatus result;
	result = AudioFileOpenURL (
	
		(CFURLRef) self.audioFileURL,
		0x01, //fsRdPerm,						// read only
		0, // or kAudioFileM4AType
		&audioFileID
	);
   NSAssert(result == 0, @"Could not open audio file");

	UInt32 sizeOfPlaybackFormatASBDStruct = sizeof ([self audioFormat]);
	
	// get the AudioStreamBasicDescription format for the playback file
	result = AudioFileGetProperty (
	
		[self audioFileID], 
		kAudioFilePropertyDataFormat,
		&sizeOfPlaybackFormatASBDStruct,
		&audioFormat
	);
   NSAssert(result == 0, @"Could not get audio file");
   
}

- (void) setupPlaybackAudioQueueObject {

	// create the playback audio queue object
	AudioQueueNewOutput (
		&audioFormat,
		playbackCallback,
		self, 
      CFRunLoopGetCurrent (),
		kCFRunLoopCommonModes,
		0,								// run loop flags
		&queueObject
	);
	
	// set the volume of the playback audio queue
	[self setGain: 1.0];
	
	AudioQueueSetParameter (
		queueObject,
		kAudioQueueParam_Volume,
		gain
	);
	
	//[self enableLevelMetering];

	// add the property listener callback to the playback audio queue
	AudioQueueAddPropertyListener (
		[self queueObject],
		kAudioQueueProperty_IsRunning,
		propertyListenerCallback,
		self
	);

	// copy the audio file's magic cookie to the audio queue object to give it 
	// as much info as possible about the audio data to play
	[self copyMagicCookieToQueue: queueObject fromFile: audioFileID];
}

- (void) setupAudioQueueBuffers {

	// calcluate the size to use for each audio queue buffer, and calculate the
	// number of packets to read into each buffer
	[self calculateSizesFor: (Float64) kSecondsPerBuffer];

	// prime the queue with some data before starting
	// allocate and enqueue buffers				
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < kNumberAudioDataBuffers; ++bufferIndex) {
	
		AudioQueueAllocateBuffer (
			[self queueObject],
			[self bufferByteSize],
			&buffers[bufferIndex]
		);

		playbackCallback ( 
			self,
			[self queueObject],
			buffers[bufferIndex]
		);
		
		if ([self donePlayingFile]) break;
	}
}


- (void) play {
   AudioSessionSetActive (true);
	[self setupAudioQueueBuffers];

	AudioQueueStart (
		self.queueObject,
		NULL			// start time. NULL means ASAP.
	);
}

- (void) stop {
   AudioSessionSetActive (false);
	AudioQueueStop (
		self.queueObject,
		self.audioPlayerShouldStopImmediately
	);
	AudioFileClose (self.audioFileID);	
}


- (void) pause {

	AudioQueuePause (
		self.queueObject
	);
}


- (void) resume {

	AudioQueueStart (
		self.queueObject,
		NULL			// start time. NULL means ASAP
	);
}


- (void) calculateSizesFor: (Float64) seconds {

	UInt32 maxPacketSize;
	UInt32 propertySize = sizeof (maxPacketSize);
	
	AudioFileGetProperty (
		audioFileID, 
		kAudioFilePropertyPacketSizeUpperBound,
		&propertySize,
		&maxPacketSize
	);

	static const int maxBufferSize = 0x10000;	// limit maximum size to 64K
	static const int minBufferSize = 0x4000;	// limit minimum size to 16K

	if (audioFormat.mFramesPerPacket) {
		Float64 numPacketsForTime = audioFormat.mSampleRate / audioFormat.mFramesPerPacket * seconds;
		[self setBufferByteSize: numPacketsForTime * maxPacketSize];
	} else {
		// if frames per packet is zero, then the codec doesn't know the relationship between 
		// packets and time -- so we return a default buffer size
		[self setBufferByteSize: maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize];
	}
	
		// we're going to limit our size to our default
	if (bufferByteSize > maxBufferSize && bufferByteSize > maxPacketSize) {
		[self setBufferByteSize: maxBufferSize];
	} else {
		// also make sure we're not too small - we don't want to go the disk for too small chunks
		if (bufferByteSize < minBufferSize) {
			[self setBufferByteSize: minBufferSize];
		}
	}
	
	[self setNumPacketsToRead: self.bufferByteSize / maxPacketSize];
}


- (void) dealloc {
	AudioQueueDispose (
		queueObject, 
		YES
	);
	
	[super dealloc];
}

@end
