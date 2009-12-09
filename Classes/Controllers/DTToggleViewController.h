//
//  DTToggleViewController.h
//  iRevealMaui
//
//  Created by Ilan Volow on 10/27/09.
//  Copyright 2009 ZWorkBench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTActsAsChildViewController.h"
#import "DTViewController.h"

@class DTToggleViewController;

/*!
    @class       DTToggleViewController 
    @superclass  UIViewController {
    @abstract    The DTToggleViewController implements a view controller that allows switching between a front and back view.
*/
@interface DTToggleViewController : DTViewController {

	UIViewController  <DTActsAsChildViewController> *frontViewController;
	UIViewController  <DTActsAsChildViewController> *backViewController;
	UIImage *navButtonImage;
	BOOL backIsShowing;
}

@property(retain, nonatomic) UIViewController <DTActsAsChildViewController> *frontViewController;
@property(retain, nonatomic) UIViewController <DTActsAsChildViewController> *backViewController;
@property(retain, nonatomic, readonly) UIViewController <DTActsAsChildViewController> *currentViewController;
@property(retain, nonatomic, readonly) UIViewController <DTActsAsChildViewController> *hiddenViewController;
@property(retain, nonatomic) UIImage *navButtonImage;

#pragma mark -
#pragma mark ACTIONS

- (IBAction)toggleViews:(id)sender;
+ (DTToggleViewController *)controllerWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController;

@end
