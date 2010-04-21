//
//  DTTabBarController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 2/19/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTActivityIndicatorView.h"

@interface DTTabBarController : UITabBarController <UITabBarControllerDelegate> {
	id <UITabBarControllerDelegate> secondaryDelegate;
	BOOL persistSelectedIndex;
	BOOL shouldFadeDefaultPNG;
	UIView *dtWindowOverlay;
	DTActivityIndicatorView *dtActivityIndicator;
}

@property (nonatomic) BOOL persistSelectedIndex;
@property (nonatomic) BOOL shouldFadeDefaultPNG;
@property (nonatomic, retain) UIView *windowOverlay;
@property (nonatomic, retain, readonly) DTActivityIndicatorView *activityIndicator;

- (void)fadeWindowOverlay;

@end
