//
//  Created by Christopher Garrett on 7/17/08.
//  Copyright ZWorkbench, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioRecorder : AudioQueueObject {

	BOOL	stopping;
}

@property (readwrite) BOOL	stopping;

- (void) copyEncoderMagicCookieToFile: (AudioFileID) file fromQueue: (AudioQueueRef) queue;
- (void) setupRecording;

- (void) record;
- (void) stop;

@end
