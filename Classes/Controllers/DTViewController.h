//
//  DTViewController.h
//
//  Created by Ilan Volow on 11/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTActsAsChildViewController.h"
#import "DTActivityIndicatorView.h"

@interface DTViewController : UIViewController <DTActsAsChildViewController> {
	UIViewController *dtContainerViewController;
	UIView *dtWindowOverlay;
	BOOL shouldAutorotateToPortrait;
	BOOL shouldAutorotateToLandscape;
	BOOL shouldAutorotateUpsideDown;
	BOOL hasAppeared;
	DTActivityIndicatorView *dtActivityIndicator;
}

@property (nonatomic, assign) UIViewController *containerViewController;
@property (nonatomic, retain) UIView *windowOverlay;
@property (nonatomic) BOOL shouldAutorotateToPortrait;
@property (nonatomic) BOOL shouldAutorotateToLandscape;
@property (nonatomic) BOOL shouldAutorotateUpsideDown;
@property (nonatomic) BOOL hasAppeared;
@property (nonatomic, retain, readonly) DTActivityIndicatorView *activityIndicator;

// Called before the first viewWillAppear:
- (void)viewWillFirstAppear:(BOOL)animated;

// Called before the first viewDidAppear:
- (void)viewDidFirstAppear:(BOOL)animated;

- (void)fadeWindowOverlay;

// Subclasses can override this and set the three shouldAutorotate* properties to allow autorotation
- (void)setAutorotationProperties;

// These methods can be used to implement logic that should be called before and after viewDidLoad, viewDid/WillAppear:, and 
// viewDid/WillDisappear:, whether the controller is being used as a top level controller, or as the child of a container controller.
// When you override these methods, bear in mind that your controller may not own the screen's entire view hierarchy.
//- (void) beforeViewDidLoad:(UIView *)theTableView;
//- (void) afterViewDidLoad:(UIView *)theTableView;
//- (void) beforeView:(UIView *)theTableView willAppear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView willAppear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView didAppear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView didAppear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView willDisappear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView willDisappear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView didDisappear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView didDisappear:(BOOL)animated;

@end
