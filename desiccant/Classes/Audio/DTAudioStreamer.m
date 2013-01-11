//
//  DTAudioStreamer.m
//  desiccant
//
//  Created by Curtis Duhn on 3/29/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTAudioStreamer.h"
#import "ZestUtilities.h"

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
NSString * const DTAudioStreamerDidStartPlaying = @"DTAudioStreamerDidStartPlaying";
NSString * const DTAudioStreamerDidPause = @"DTAudioStreamerDidPause";

static const NSString *ItemStatusContext;

//------------------
// Private view class that DTAudioStreamer adds to the view hierarchy to support background audio controls.
@interface DTHiddenAudioStreamerView : UIView {
}
@end
@implementation DTHiddenAudioStreamerView
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPause ||
            event.subtype == UIEventSubtypeRemoteControlPlay ||
            event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) 
        {
            if ([[DTAudioStreamer sharedStreamer] isPlaying]) {
                [[DTAudioStreamer sharedStreamer] pause];
            }
            else {
                [[DTAudioStreamer sharedStreamer] play];
            }
        }
    }
}
@end


//------------------
// DTAudioStreamer
@interface DTAudioStreamer()
- (void)setAudioSessionToPlayInTheBackgroundWhenTheScreenIsLocked;
- (void)notify:(NSString *)notificationName;
- (void)mainThreadNotify:(NSString *)notificationName;
- (void)removeObserversForItem:(AVPlayerItem *)item;
- (void)startRemoteControls;
- (void)stopRemoteControls;
@property (nonatomic, retain) id timeObserver;
@property (nonatomic, retain) DTHiddenAudioStreamerView *hiddenResponderView;
@end


@implementation DTAudioStreamer
@synthesize notificationCenter, inputAvailable, playerItem, player, readyToPlay, error, url, timeObserver, supportRemoteControls, hiddenResponderView;

#pragma Memory management

- (void)dealloc {
    if (self.timeObserver) [self.player removeTimeObserver:self.timeObserver];
    [self removeObserversForItem:self.playerItem];
    self.timeObserver = nil;
    self.notificationCenter = nil;
    self.playerItem = nil;
    self.player = nil;
    self.error = nil;
    self.url = nil;
    self.hiddenResponderView = nil;
    [super dealloc];
}

#pragma Constructors

+ (DTAudioStreamer *)sharedStreamer {
	return (DTAudioStreamer *)[self loadedSingleton];
}

- (id)init {
    if ((self = [super init])) {
        [[AVAudioSession sharedInstance] setDelegate:self];
        [self setAudioSessionToPlayInTheBackgroundWhenTheScreenIsLocked];  
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.inputAvailable = NO;
        self.readyToPlay = NO;
        self.supportRemoteControls = YES;
    }
    return self;
}

#pragma mark DTSingleton

+ (NSObject **)staticSingleton {
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
        if ([self isPlaying]) {
            [self stop];
        }
        self.url = theURL;
        if (self.playerItem) {
            [self removeObserversForItem:self.playerItem];
            self.readyToPlay = NO;
            self.error = nil;
        }
        self.playerItem = [AVPlayerItem playerItemWithURL:theURL];
        [playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidPlayToEndTime:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        if (DTOSVersion >= 4.3) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemFailedToPlayToEndTime:)
                                                         name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                       object:playerItem];
        }
//        if (!player) {
            if (self.timeObserver) [self.player removeTimeObserver:self.timeObserver];
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,4) queue:NULL usingBlock:^(CMTime time) {
                [self notify:DTAudioStreamerCurrentTimeDidChange];
            }];
//        }
//        else {
//            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];        
//        }
    }
}

- (void)play {
    [self startRemoteControls];
    [player play];
    [self notify:DTAudioStreamerDidStartPlaying];    
}

- (void)pause {
    [player pause];
    [self notify:DTAudioStreamerDidPause];    
}

- (void)stop {
    [self stopRemoteControls];
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
    AVPlayerItem *item = object;
    if (context == &ItemStatusContext) {
        if (item) {
            if ([item status] == AVPlayerItemStatusReadyToPlay) {
                self.readyToPlay = YES;
                self.error = nil;
                [self notify:DTAudioStreamerItemStatusReadyToPlay];
            }
            else if ([item status] == AVPlayerItemStatusFailed) {
                self.readyToPlay = NO;
                self.error = [item error];
                [self stopRemoteControls];
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
    [self stopRemoteControls];
    [self notify:DTAudioStreamerItemDidPlayToEndTime];
}

- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification {
    [self stopRemoteControls];
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
}

- (void)notify:(NSString *)notificationName {
    [self performSelectorOnMainThread:@selector(mainThreadNotify:) 
                           withObject:notificationName 
                        waitUntilDone:NO];
}

- (void)mainThreadNotify:(NSString *)notificationName {
    [notificationCenter postNotificationName:notificationName object:self];
}

- (void)removeObserversForItem:(AVPlayerItem *)item {
    if (item) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:item];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:item];
    }
}

- (void)startRemoteControls {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    if (activationError) { 
        NSLog(@"Activation Error: %@", activationError);
    }
    
    if (!self.hiddenResponderView && self.supportRemoteControls) {
        self.hiddenResponderView = [[[DTHiddenAudioStreamerView alloc] initWithFrame:CGRectZero] autorelease];
        self.hiddenResponderView.backgroundColor = [UIColor clearColor];
        [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] addSubview:self.hiddenResponderView];
        [self.hiddenResponderView becomeFirstResponder];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
}

- (void)stopRemoteControls {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *activationError = nil;
    [audioSession setActive:NO error:&activationError];
    if (activationError) { 
        NSLog(@"Activation Error: %@", activationError);
    }

    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self.hiddenResponderView resignFirstResponder];
    [self.hiddenResponderView removeFromSuperview];
    self.hiddenResponderView = nil;
}


@end
