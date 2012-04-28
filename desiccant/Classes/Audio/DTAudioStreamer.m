//
//  DTAudioStreamer.m
//  desiccant
//
//  Created by Curtis Duhn on 3/29/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTAudioStreamer.h"

static DTAudioStreamer *loadedStreamer = nil;
NSString * const DTAudioStreamerDidBeginInterruption = @"DTAudioStreamerDidBeginInterruption";
NSString * const DTAudioStreamerDidEndInterruption = @"DTAudioStreamerDidEndInterruption";
NSString * const DTAudioStreamerInputIsAvailableChanged = @"DTAudioStreamerInputIsAvailableChanged";
NSString * const DTAudioStreamerItemDidPlayToEndTime = @"DTAudioStreamerItemDidPlayToEndTime";
NSString * const DTAudioStreamerItemFailedToPlayToEndTimeNotification = @"DTAudioStreamerItemFailedToPlayToEndTimeNotification";
NSString * const DTAudioStreamerItemStatusReadyToPlay = @"DTAudioStreamerItemStatusReadyToPlay";
NSString * const DTAudioStreamerItemStatusFailed = @"DTAudioStreamerItemStatusFailed";
NSString * const DTAudioStreamerItemStatusUnknown = @"DTAudioStreamerItemStatusUnknown";
NSString * const DTAudioStreamerCurrentTimeDidChange = @"DTAudioStreamerCurrentTimeDidChange";

static const NSString *ItemStatusContext;

@interface DTAudioStreamer()
- (void)setAudioSessionToPlayInTheBackgroundWhenTheScreenIsLocked;
- (void)notify:(NSString *)notificationName;
- (void)mainThreadNotify:(NSString *)notificationName;
@end

@implementation DTAudioStreamer
@synthesize notificationCenter, inputAvailable, playerItem, player, readyToPlay, error, url;

#pragma Memory management

- (void)dealloc {
    self.notificationCenter = nil;
    self.playerItem = nil;
    self.player = nil;
    self.error = nil;
    self.url = nil;
    [super dealloc];
}

#pragma Constructors

+ (DTAudioStreamer *)sharedStreamer {
	return (DTAudioStreamer *)[self loadedSingleton];
}

- (id)init {
    if ((self = [super init])) {
        [self setAudioSessionToPlayInTheBackgroundWhenTheScreenIsLocked];  
        [[AVAudioSession sharedInstance] setDelegate:self];
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.inputAvailable = NO;
        self.readyToPlay = NO;
    }
    return self;
}

#pragma mark DTSingleton

+ (id *)staticSingleton {
	return &loadedStreamer;
}

#pragma mark Dynamic properties

- (void)setRate:(float)newRate {
    self.player.rate = newRate;
}

- (float)rate {
    return self.player.rate;
}


#pragma mark Public

- (void)loadURL:(NSURL *)theURL {
    if (![self.url isEqual:theURL]) {
        self.url = theURL;
        self.playerItem = [AVPlayerItem playerItemWithURL:theURL];
        [playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidPlayToEndTime:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemFailedToPlayToEndTime:)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:playerItem];
        if (!player) {
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,10) queue:NULL usingBlock:^(CMTime time) {
                [self notify:DTAudioStreamerCurrentTimeDidChange];
            }];
        }
        else {
            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];        
        }
    }
}

- (void)play {
    [player play];
}

- (void)pause {
    [player pause];
}

- (void)stop {
    [player pause];
    [self seekToTime:CMTimeMake(0, 1)];
}


- (CMTime)currentTime {
    return [player currentTime];
}

- (CMTime)duration {
    return [player.currentItem.asset duration];
}

- (void)seekToTime:(CMTime)time {
    [player seekToTime:time];
}

- (BOOL)isPlaying {
    return self.rate > 0.0;
}

#pragma mark Key/Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context 
{
    if (context == &ItemStatusContext) {
        if (player.currentItem) {
            if ([player.currentItem status] == AVPlayerItemStatusReadyToPlay) {
                self.readyToPlay = YES;
                self.error = nil;
                [self notify:DTAudioStreamerItemStatusReadyToPlay];
            }
            else if ([player.currentItem status] == AVPlayerItemStatusFailed) {
                self.readyToPlay = NO;
                self.error = [player.currentItem error];
                [self notify:DTAudioStreamerItemStatusFailed];
            }
            else {
                self.readyToPlay = NO;
                self.error = nil;
                [self notify:DTAudioStreamerItemStatusUnknown];
            }
        }
        else {
            self.readyToPlay = NO;
            self.error = nil;
            [self notify:DTAudioStreamerItemStatusUnknown];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

#pragma mark AVPlayerItem notifications

- (void)playerItemDidPlayToEndTime:(NSNotification *)notification {
    [player seekToTime:kCMTimeZero];
    [self notify:DTAudioStreamerItemDidPlayToEndTime];
}

- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification {
    [self notify:DTAudioStreamerItemFailedToPlayToEndTimeNotification];
}

#pragma mark AVAudioSessionDelegate methods

- (void)beginInterruption {
    [self notify:DTAudioStreamerDidBeginInterruption];
}

- (void)endInterruption {
    [self notify:DTAudioStreamerDidEndInterruption];
}

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable {
    self.inputAvailable = isInputAvailable;
    [self notify:DTAudioStreamerInputIsAvailableChanged];
}


#pragma mark Private

- (void)setAudioSessionToPlayInTheBackgroundWhenTheScreenIsLocked {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError) { 
        NSLog(@"Category Error: %@", setCategoryError);
    }
    
    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    if (activationError) { 
        NSLog(@"Activation Error: %@", activationError);
    }
}

- (void)notify:(NSString *)notificationName {
    [self performSelectorOnMainThread:@selector(mainThreadNotify:) 
                           withObject:notificationName 
                        waitUntilDone:NO];
}

- (void)mainThreadNotify:(NSString *)notificationName {
    [notificationCenter postNotificationName:notificationName object:self];
}

@end
