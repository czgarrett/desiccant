//
//  DTNavigationControllerDelegate.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTNavigationControllerDelegate.h"


@interface DTNavigationControllerDelegate()
@end

@implementation DTNavigationControllerDelegate

+ (id)delegate {
	return [[[self alloc] init] autorelease];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[navigationController showOrHideToolbarForViewController:viewController];
}

@end
