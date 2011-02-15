//
//  Created by Christopher Garrett on 7/17/08.
//  Copyright ZWorkbench, Inc. 2008. All rights reserved.
//


#include <AudioToolbox/AudioToolbox.h>
#import "AudioQueueObject.h"


@implementation AudioQueueObject

@synthesize queueObject;
@synthesize audioFileID;
@synthesize audioFileURL;
@synthesize audioFormat;
@synthesize audioLevels;
@synthesize startingPacketNumber;
@synthesize delegate;

- (void) incrementStartingPacketNumberBy: (UInt32) inNumPackets {

	startingPacketNumber += inNumPackets;
}


- (BOOL) isRunning {

	UInt32		isRunning;
	UInt32		propertySize = sizeof (UInt32);
	OSStatus	result;
	
	 result =	AudioQueueGetProperty (
					queueObject,
					kAudioQueueProperty_IsRunning,
					&isRunning,
					&propertySize
				);

	if (result != noErr) {
		return false;
	} else {
		return isRunning;
	}
}


// an audio queue object doesn't provide audio level information unless you 
// enable it to do so
- (void) enableLevelMetering {

	// allocate the memory needed to store audio level information
	self.audioLevels = (AudioQueueLevelMeterState *) calloc (sizeof (AudioQueueLevelMeterState), audioFormat.mChannelsPerFrame);

	UInt32 trueValue = true;

	AudioQueueSetProperty (
		self.queueObject,
		kAudioQueueProperty_EnableLevelMetering,
		&trueValue,
		sizeof (UInt32)
	);
}


// gets audio levels from the audio queue object, to 
// display using the bar graph in the application UI
- (void) getAudioLevels: (Float32 *) levels peakLevels: (Float32 *) peakLevels {

	UInt32 propertySize = audioFormat.mChannelsPerFrame * sizeof (AudioQueueLevelMeterState);
	
	AudioQueueGetProperty (
		self.queueObject,
		(AudioQueuePropertyID) kAudioQueueProperty_CurrentLevelMeter,
		self.audioLevels,
		&propertySize
	);
	
	levels[0]		= self.audioLevels[0].mAveragePower;
	peakLevels[0]	= self.audioLevels[0].mPeakPower;
}

- (void) dealloc {
	
	[super dealloc];
}

@end
