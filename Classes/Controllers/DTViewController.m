//
//  DTViewController.m
//  iRevealMaui
//
//  Created by Ilan Volow on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DTViewController.h"


@implementation DTViewController
@synthesize containerViewController;

- (void) dealloc {
	self.containerViewController = nil;
	[super dealloc];
}

- (UINavigationController *)navigationController {
	if (containerViewController) {
		return containerViewController.navigationController;
	}
	else {
		return super.navigationController;
	}
}

- (UINavigationItem *)navigationItem {
	if (containerViewController) {
		return containerViewController.navigationItem;
	}
	else {
		return super.navigationItem;
	}
}

- (UIViewController *)parentViewController {
	if (containerViewController) {
		return containerViewController.parentViewController;
	}
	else {
		return super.parentViewController;
	}
}

@end
