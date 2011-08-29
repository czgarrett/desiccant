//
//  DTViewController.m
//
//  Created by Ilan Volow on 11/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTViewController.h"
#import "Zest.h"
#import "DTCompositeViewController.h"

@interface DTViewController()
@property (nonatomic, assign) UIViewController *dtContainerViewController;
@property (nonatomic, retain) UIView *dtWindowOverlay;
@property (nonatomic, retain) DTActivityIndicatorView *dtActivityIndicator;
@end


@implementation DTViewController
@synthesize hasAppeared, dtContainerViewController, dtWindowOverlay, shouldAutorotateToPortrait, shouldAutorotateToLandscape, shouldAutorotateUpsideDown, dtActivityIndicator;

#pragma mark Memory management

- (void) dealloc {
	self.dtContainerViewController = nil;
   [self releaseRetainedSubviews];
	[super dealloc];
}

- (void) releaseRetainedSubviews {
	self.dtWindowOverlay = nil;
	self.dtActivityIndicator = nil;
}


#pragma mark Constructors

- (id)init {
	if ((self = [super init])) {
		[self setAutorotationProperties];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setAutorotationProperties];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self setAutorotationProperties];
	}
	return self;
}

#pragma mark Public methods

- (void)viewWillFirstAppear:(BOOL)animated {
}

- (void)viewDidFirstAppear:(BOOL)animated {
}

- (void)setWindowOverlay:(UIView *)theView {
	self.dtWindowOverlay = theView;
	theView.center = [[UIScreen mainScreen] center];
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

#pragma mark Dynamic properties

- (DTActivityIndicatorView *)activityIndicator {
	unless (dtActivityIndicator) {
		self.dtActivityIndicator = [[[DTActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		dtActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	}
	unless (dtActivityIndicator.superview) {
		dtActivityIndicator.hidesWhenStopped = YES;
		dtActivityIndicator.center = self.view.center;
		[self.view.superview addSubview:dtActivityIndicator];
	}
	
	return self.dtActivityIndicator;
}

#pragma mark DTActsAsChildViewController methods

- (void)setContainerViewController:(UIViewController *)theController {
	id oldController = self.dtContainerViewController;
	self.dtContainerViewController = theController;
	if (theController && [theController respondsToSelector:@selector(addSubviewController:)]) {
		[(id)theController addSubviewController:self];
	}
	else if (!theController && [oldController respondsToSelector:@selector(removeSubviewController:)]) {
		[(id)oldController removeSubviewController:self];
	}
}

- (UIViewController *)containerViewController {
	return dtContainerViewController;
}

- (UIViewController *)topContainerViewController {
	if ([[self containerViewController] respondsToSelector:@selector(topContainerViewController)]) {
		return [(UIViewController <DTActsAsChildViewController> *)[self containerViewController] topContainerViewController];
	}
	else {
		return self;
	}
}

#pragma mark UIViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// When self is the root view controller (or one of its nested controllers), but isn't currently visible, 
	// this allows the controller that is visible to autorotate to orientations that this controller may not support.
	// Necessary because UITabBarController returns the logical AND of its viewControllers' responses, and
	// UINavigationController returns the response of its root viewController.
	if (self.tabBarController && 
		self.tabBarController.selectedViewController != [self topContainerViewController] && 
		self.tabBarController.selectedViewController != self.navigationController) {
		return [self.tabBarController.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	}
	else if (self.navigationController && self.navigationController.topViewController != [self topContainerViewController]) {
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

- (void) viewDidUnload {
	[super viewDidUnload];
   [self releaseRetainedSubviews];
}

- (void) viewWillAppear:(BOOL)animated {
//	[self beforeView:self.view willAppear:animated];
	unless (self.hasAppeared) [self viewWillFirstAppear:animated];
	if (!self.containerViewController) [super viewWillAppear:animated];
//	[self afterView:self.view willAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
//	[self beforeView:self.view didAppear:animated];
	unless (self.hasAppeared) {
		self.hasAppeared = YES;
		[self viewDidFirstAppear:animated];
	}
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
