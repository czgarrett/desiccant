//
//  AudioManager.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/31/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"


@interface AudioManager : NSObject {
   NSMutableDictionary *players;
}

//+ (AudioManager *)instance;
//+ (void) releaseInstance;
//
//- (AudioPlayer *) newPlayerForSound: (NSString *) soundFileName;
//- (AudioPlayer *) playerForSound: (NSString *)soundFileName;
//- (void) playSound: (NSString *)soundFileName;
//- (void) stopSound: (NSString *)soundFileName;
//- (void) stopAllPlayers;
@end
