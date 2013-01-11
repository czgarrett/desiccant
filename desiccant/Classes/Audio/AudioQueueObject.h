//
//  Created by Christopher Garrett on 7/17/08.
//  Copyright ZWorkbench, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

#define kNumberAudioDataBuffers	3

@protocol AudioQueueObjectDelegate;

@interface AudioQueueObject : NSObject {

	AudioQueueRef					queueObject;					// the audio queue object being used for playback
	AudioFileID						audioFileID;					// the identifier for the audio file to play
	NSURL *audioFileURL;
	AudioStreamBasicDescription		audioFormat;
	AudioQueueLevelMeterState		*audioLevels;
	SInt64							startingPacketNumber;			// the current packet number in the playback file
	id	<AudioQueueObjectDelegate>							delegate;
}

@property (readwrite)			AudioQueueRef				queueObject;
@property (readwrite)			AudioFileID					audioFileID;
@property (retain)			NSURL *audioFileURL;
@property (readwrite)			AudioStreamBasicDescription	audioFormat;
@property (readwrite)			AudioQueueLevelMeterState	*audioLevels;
@property (readwrite)			SInt64						startingPacketNumber;
@property (nonatomic, retain)	id <AudioQueueObjectDelegate> delegate;


- (void) incrementStartingPacketNumberBy:  (UInt32) inNumPackets;
- (void) enableLevelMetering;
- (void) getAudioLevels: (Float32 *) levels peakLevels: (Float32 *) peakLevels;
- (BOOL) isRunning;

@end