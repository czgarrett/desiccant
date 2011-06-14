//
//  AudioManager.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/31/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "AudioManager.h"

static AudioManager *audioManager;


@implementation AudioManager

+ (AudioManager *)instance {
   if (!audioManager) {
      audioManager = [[AudioManager alloc] init];
   }
   return audioManager;
}

+ (void) releaseInstance {
   if (audioManager) {
      [audioManager stopAllPlayers];
   }
}

- (id) init {
   if (self == [super init]) {
      players = [[NSMutableDictionary alloc] init];
   }
   return self;
}


- (void) stopAllPlayers {
   NSEnumerator *playerEnum = [players objectEnumerator];
   AudioPlayer *player;
   while (player = (AudioPlayer *)[playerEnum nextObject]) {
      player.audioPlayerShouldStopImmediately = YES;
      [player stop];
   }   
}

- (void) stopSound: (NSString *)soundFileName {
   AudioPlayer *player = [self playerForSound: soundFileName];
   if (player) [player stop];
}

- (AudioPlayer *) playerForSound: (NSString *)soundFileName {
   return (AudioPlayer *) [players objectForKey: soundFileName];
}

- (AudioPlayer *) createPlayerForSound: (NSString *) soundFileName {
   AudioPlayer *existing = [self playerForSound: soundFileName];
   if (existing) {
      existing.audioPlayerShouldStopImmediately = YES;
      [existing stop];
      [players removeObjectForKey: soundFileName];
   }
   AudioPlayer *result;
   result = [[AudioPlayer alloc] initWithFileName: soundFileName];
   [players setObject: result forKey: soundFileName];
   return result;
}
- (void) playSound: (NSString *)soundFileName {
   [[self createPlayerForSound: soundFileName] play];
}


@end
