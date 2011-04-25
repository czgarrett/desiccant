//
//  DTAudioStreamer.h
//  desiccant
//
//  Created by Curtis Duhn on 3/29/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import "DTSingleton.h"

extern NSString * const DTAudioStreamerDidBeginInterruption;
extern NSString * const DTAudioStreamerDidEndInterruption;
extern NSString * const DTAudioStreamerInputIsAvailableChanged;
extern NSString * const DTAudioStreamerItemDidPlayToEndTime;
extern NSString * const DTAudioStreamerItemFailedToPlayToEndTimeNotification;
extern NSString * const DTAudioStreamerItemStatusReadyToPlay;
extern NSString * const DTAudioStreamerItemStatusFailed;
extern NSString * const DTAudioStreamerItemStatusUnknown;
extern NSString * const DTAudioStreamerCurrentTimeDidChange;

@interface DTAudioStreamer : DTSingleton {
}

@property (nonatomic, retain) NSNotificationCenter *notificationCenter;
@property (nonatomic) BOOL inputAvailable;
@property (nonatomic) BOOL readyToPlay;
@property (nonatomic, retain) AVPlayerItem *playerItem;
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) NSError *error;
@property (nonatomic) float rate;
@property (nonatomic, retain) NSURL *url;

+ (DTAudioStreamer *)sharedStreamer;
- (void)loadURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;
- (CMTime)currentTime;
- (CMTime)duration;
- (void)seekToTime:(CMTime)time;
- (BOOL)isPlaying;

@end
