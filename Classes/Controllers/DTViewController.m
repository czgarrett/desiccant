//
//  DTViewController.m
//  iRevealMaui
//
//  Created by Ilan Volow on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DTViewController.h"

@interface DTViewController()
@property (nonatomic, assign) UIViewController *dtContainerViewController;
@property (nonatomic, retain) UIView *dtWindowOverlay;
@end


@implementation DTViewController
@synthesize dtContainerViewController, dtWindowOverlay, shouldAutorotateToPortrait, shouldAutorotateToLandscape, shouldAutorotateUpsideDown;

#pragma mark Memory management

- (void) dealloc {
	self.dtContainerViewController = nil;
	self.dtWindowOverlay = nil;
	[super dealloc];
}

#pragma mark Constructors

- (id)init {
	if (self = [super init]) {
		[self setAutorotationProperties];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setAutorotationProperties];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self setAutorotationProperties];
	}
	return self;
}

#pragma mark Public methods

- (void)setWindowOverlay:(UIView *)theView {
	self.dtWindowOverlay = theView;
	theView.frame = [[UIScreen mainScreen] bounds];
	[[[UIApplication sharedApplication] keyWindow] addSubview:theView];
}

- (UIView *)windowOverlay {
	return self.dtWindowOverlay;
}

- (void)fadeWindowOverlay {
	if (self.windowOverlay) {
		[UIView beginAnimations:@"WindowOverlayFadeAnimation" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self.windowOverlay];
		[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
		self.windowOverlay.alpha = 0.0;
		[UIView commitAnimations];
	}
}

- (void)setAutorotationProperties {
	self.shouldAutorotateToPortrait = YES;
	self.shouldAutorotateToLandscape = NO;
	self.shouldAutorotateUpsideDown = NO;
}



#pragma mark DTActsAsChildViewController methods

- (void)setContainerViewController:(UIViewController *)theController {
	self.dtContainerViewController = theController;
}

- (UIViewController *)containerViewController {
	return dtContainerViewController;
}

#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (self.navigationController && self.navigationController.topViewController != self) {
		// When self is the root view controller, this allows the top view controller to autorotate to orientations 
		// that self doesn't support.
		return [self.navigationController.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
	else {
		return ((self.shouldAutorotateToPortrait && interfaceOrientation == UIInterfaceOrientationPortrait) ||
				(self.shouldAutorotateToLandscape && (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
													  interfaceOrientation == UIInterfaceOrientationLandscapeRight)) ||
				(self.shouldAutorotateUpsideDown && interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
	}
}


//- (void) viewDidLoad {
////	[self beforeViewDidLoad:self.view];
//	[super viewDidLoad];
////	[self afterViewDidLoad:self.view];
//}

//- (void) viewDidUnload {
//	[super viewDidUnload];
//}

- (void) viewWillAppear:(BOOL)animated {
//	[self beforeView:self.view willAppear:animated];
	if (!self.containerViewController) [super viewWillAppear:animated];
//	[self afterView:self.view willAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
//	[self beforeView:self.view didAppear:animated];
	if (!self.containerViewController) [super viewDidAppear:animated];
//	[self afterView:self.view didAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
//	[self beforeView:self.view willDisappear:animated];
	if (!self.containerViewController) [super viewWillDisappear:animated];
//	[self afterView:self.view willDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
//	[self beforeView:self.view didDisappear:animated];
	if (!self.containerViewController) [super viewDidDisappear:animated];
//	[self afterView:self.view didDisappear:animated];
}

//- (void) beforeViewDidLoad:(UIView *)theTableView {}
//- (void) afterViewDidLoad:(UIView *)theTableView {}
//- (void) beforeView:(UIView *)theTableView willAppear:(BOOL)animated {}
//- (void) afterView:(UIView *)theTableView willAppear:(BOOL)animated {}
//- (void) beforeView:(UIView *)theTableView didAppear:(BOOL)animated {}
//- (void) afterView:(UIView *)theTableView didAppear:(BOOL)animated {}
//- (void) beforeView:(UIView *)theTableView willDisappear:(BOOL)animated {}
//- (void) afterView:(UIView *)theTableView willDisappear:(BOOL)animated {}
//- (void) beforeView:(UIView *)theTableView didDisappear:(BOOL)animated {}
//- (void) afterView:(UIView *)theTableView didDisappear:(BOOL)animated {}

- (UINavigationController *)navigationController {
	if (self.containerViewController) {
		return self.containerViewController.navigationController;
	}
	else {
		return super.navigationController;
	}
}

- (UINavigationItem *)navigationItem {
	if (self.containerViewController) {
		return self.containerViewController.navigationItem;
	}
	else {
		return super.navigationItem;
	}
}

- (UIViewController *)parentViewController {
	if (self.containerViewController) {
		return self.containerViewController.parentViewController;
	}
	else {
		return super.parentViewController;
	}
}

//- (UIView *)view {
//	if (self.containerViewController) {
//		??? // Figure out what to return here
////		return self.containerTableViewController.view;
//	}
//	else {
//		return super.view;
//	}
//}

@end
