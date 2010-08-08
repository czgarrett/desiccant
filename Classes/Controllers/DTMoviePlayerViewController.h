//
//  DTMoviePlayerViewController.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 8/6/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTViewController.h"
#import "MediaPlayer/MPMoviePlayerController.h"

@interface DTMoviePlayerViewController : DTViewController {
	MPMoviePlayerController *mp;
	NSURL  *movieURL;
	UIStatusBarStyle oldStatusBarStyle;
	UIInterfaceOrientation oldStatusBarOrientation;
	BOOL oldStatusBarHidden;
	UIColor *oldWindowColor;
}

- (id)initWithURL:(NSURL *)theURL;
+ (id)controllerWithURL:(NSURL *)theURL;
- (void)readyPlayer;

@end
