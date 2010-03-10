//
//  UINavigationController+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/25/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (Zest)

- (void) popToViewControllerWithClass: (Class) newClass animated: (BOOL)animated;
- (UIViewController *) firstViewControllerWithClass: (Class) searchClass;
- (void)showOrHideToolbarForViewController:(UIViewController *)controller;

@property (readonly) UIViewController *rootViewController;

@end
