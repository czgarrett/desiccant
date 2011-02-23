//
//  Created by Christopher Garrett on 7/17/08.
//  Copyright ZWorkbench, Inc. 2008. All rights reserved.
//


#include <AudioToolbox/AudioToolbox.h>
#import "AudioQueueObject.h"
#import "AudioRecorder.h"

static void recordingCallback (
	void								*inUserData,
	AudioQueueRef						inAudioQueue,
	AudioQueueBufferRef					inBuffer,
	const AudioTimeStamp				*inStartTime,
	UInt32								inNumPackets,
	const AudioStreamPacketDescription	*inPacketDesc
) {
	// This callback, being outside the implementation block, needs a reference to the AudioRecorder object
	AudioRecorder *recorder = (AudioRecorder *) inUserData;
		
	// if there is audio data, write it to the file
	if (inNumPackets > 0) {

		AudioFileWritePackets (
			[recorder audioFileID],
			FALSE,
			inBuffer->mAudioDataByteSize,
			inPacketDesc,
			recorder.startingPacketNumber,
			&inNumPackets,
			inBuffer->mAudioData
		);
		
		[recorder incrementStartingPacketNumberBy:  (UInt32) inNumPackets];
	}

	// if not stopping, re-enqueue the buffer so that it can be filled again
	if ([recorder isRunning]) {

		AudioQueueEnqueueBuffer (
			inAudioQueue,
			inBuffer,
			0,
			NULL
		);
	}
}

// Property callback function, called when a property changes. The only 
//	Audio Queue Services property as of Mac OS X v10.5.3 is kAudioQueueProperty_IsRunning
static void propertyListenerCallback (
	void					*inUserData,
	AudioQueueRef			queueObject,
	AudioQueuePropertyID	propertyID
) {
	AudioRecorder *recorder = (AudioRecorder *) inUserData;

	if (recorder.stopping) {
	
		// a codec may update its cookie at the end of an encoding session, so reapply it to the file now
		// linear PCM, as used in this app, doesn't have magic cookies. this is included in case you
		// want to change to a format that does use magic cookies.
		[recorder copyEncoderMagicCookieToFile: recorder.audioFileID fromQueue: recorder.queueObject];

		AudioFileClose (recorder.audioFileID);
	}

	[recorder.delegate audioQueueStateChanged: recorder];
}


@implementation AudioRecorder

@synthesize stopping;

- (id) initWithURL: fileURL {
	self = [super init];

	if (self != nil) {
	
		// these statements define the audio stream basic description
		// for the file to record into.
		audioFormat.mSampleRate			= 44100.00;
		audioFormat.mFormatID			= kAudioFormatLinearPCM;
		audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
		audioFormat.mFramesPerPacket	= 1;
		audioFormat.mChannelsPerFrame	= 1;
		audioFormat.mBitsPerChannel		= 16;
		audioFormat.mBytesPerPacket		= 2;
		audioFormat.mBytesPerFrame		= 2;


		AudioQueueNewInput (
			&audioFormat,
			recordingCallback,
			self,									// userData
			NULL,									// run loop
			NULL,									// run loop mode
			0,										// flags
			&queueObject
		);

		// get the record format back from the queue's audio converter --
		//	the file may require a more specific stream description than was 
		//	necessary to create the encoder.
		UInt32 sizeOfRecordingFormatASBDStruct = sizeof (audioFormat);
		
		AudioQueueGetProperty (
			queueObject,
			kAudioQueueProperty_StreamDescription,	// this constant is only available in iPhone OS
			&audioFormat,
			&sizeOfRecordingFormatASBDStruct
		);
		
		AudioQueueAddPropertyListener (
			[self queueObject],
			kAudioQueueProperty_IsRunning,
			propertyListenerCallback,
			self
		);

		[self setAudioFileURL: (NSURL *) fileURL];
		
		[self enableLevelMetering];
	}
	return self;
} 


- (void) copyEncoderMagicCookieToFile: (AudioFileID) theFile fromQueue: (AudioQueueRef) theQueue {

	OSStatus	result;
	UInt32		propertySize;
	
	// get the magic cookie, if any, from the converter		
	result =	AudioQueueGetPropertySize (
					theQueue,
					kAudioQueueProperty_MagicCookie,
					&propertySize
				);
	
	if (result == noErr && propertySize > 0) {
		// there is valid cookie data to be fetched;  get it
		Byte *magicCookie = (Byte *) malloc (propertySize);
		
		AudioQueueGetProperty (
			theQueue,
			kAudioQueueProperty_MagicCookie,
			magicCookie,
			&propertySize
		);
				
		// now set the magic cookie on the output file
		AudioFileSetProperty (
			theFile,
			kAudioQueueProperty_MagicCookie,
			propertySize,
			magicCookie
		);
				
		free (magicCookie);
	}
}


- (void) record {

	[self setupRecording];

	AudioQueueStart (
		queueObject,
		NULL			// start time. NULL means ASAP.
	);
}


- (void) stop {

	AudioQueueStop (
		queueObject,
		TRUE
	);
}


- (void) setupRecording {

	[self setStartingPacketNumber: 0];
	
	if (!self.audioFileID) {
		// create the audio file
		AudioFileCreateWithURL (
			(CFURLRef) audioFileURL,
			kAudioFileCAFType,
			&audioFormat,
			kAudioFileFlags_EraseFile,
			&audioFileID
		);		
	}

	// copy the cookie first to give the file object as much info as possible about the data going in
	[self copyEncoderMagicCookieToFile: audioFileID fromQueue: queueObject];

	// allocate and enqueue buffers
	int bufferByteSize = 65536;		// this is the maximum buffer size used by the player class
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < kNumberAudioDataBuffers; ++bufferIndex) {
	
		AudioQueueBufferRef buffer;
		
		AudioQueueAllocateBuffer (
			queueObject,
			bufferByteSize, &buffer
		);

		AudioQueueEnqueueBuffer (
			queueObject,
			buffer,
			0,
			NULL
		);
	}
}


- (void) dealloc {

	AudioQueueDispose (
		queueObject,
		TRUE
	);
	
	[super dealloc];
}

@end
