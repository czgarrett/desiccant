 //
 //  Created by Christopher Garrett on 7/17/08.
 //  Copyright ZWorkbench, Inc. 2008. All rights reserved.
 //


#import <UIKit/UIKit.h>
#import "AudioQueueObject.h"
#define kSecondsPerBuffer	0.5

@interface AudioPlayer : AudioQueueObject {

	AudioQueueBufferRef				buffers[kNumberAudioDataBuffers];	// the audio queue buffers for the audio queue

	UInt32							bufferByteSize;						// the number of bytes to use in each audio queue buffer
	UInt32							numPacketsToRead;					// the number of audio data packets to read into each audio queue buffer

	AudioStreamPacketDescription	*packetDescriptions;

	Float32							gain;								// the gain (relative audio level) for the playback audio queue


	BOOL							donePlayingFile;
	BOOL							audioPlayerShouldStopImmediately;
}

@property (readwrite) UInt32						numPacketsToRead;
@property (readwrite) AudioStreamPacketDescription	*packetDescriptions;
@property (readwrite) BOOL							donePlayingFile;
@property (readwrite) BOOL							audioPlayerShouldStopImmediately;
@property (readwrite) UInt32						bufferByteSize;
@property (readwrite) Float32						gain;			// the gain (relative audio level) for the playback audio queue

- (id) initWithURL: (NSURL *) fileURL;
- (id) initWithFileName: (NSString *)fileName;

- (void) copyMagicCookieToQueue: (AudioQueueRef) queue fromFile: (AudioFileID) playbackFileID;
- (void) calculateSizesFor: (Float64) seconds;
- (void) openPlaybackFile: (NSURL *) fileURL;
- (void) setupPlaybackAudioQueueObject;
- (void) setupAudioQueueBuffers;

- (void) play;
- (void) stop;
- (void) pause;
- (void) resume;

@end
