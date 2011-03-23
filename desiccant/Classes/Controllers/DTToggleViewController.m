//
//  DTToggleViewController.m
//
//  Created by Ilan Volow on 10/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTToggleViewController.h"
#import "Zest.h"

@interface DTToggleViewController()
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
//- (void)updateToolbarForHiddenControllerAnimated:(BOOL)animated;
//- (void)updateToolbarForCurrentControllerAnimated:(BOOL)animated;
@property (retain, nonatomic) UIViewController <DTActsAsChildViewController> *dtFrontViewController;
@property (retain, nonatomic) UIViewController <DTActsAsChildViewController> *dtBackViewController;
@end

@implementation DTToggleViewController
@synthesize dtFrontViewController, dtBackViewController, frontToggleButtonImage, backToggleButtonImage, toggleBarButtonItem;

#pragma mark Memory Management

- (void)dealloc {
	self.frontViewController.containerViewController = nil;
	self.backViewController.containerViewController = nil;
	self.frontViewController = nil;
	self.backViewController = nil;
	self.frontToggleButtonImage = nil;
	self.backToggleButtonImage = nil;
	self.toggleBarButtonItem = nil;
	
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController 
			   backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController 
		   frontToggleButtonImage:(UIImage *)theFrontToggleButtonImage
			backToggleButtonImage:(UIImage *)theBackToggleButtonImage
{
	if ((self = [super init])) {
		self.frontViewController = aFrontController;
		self.backViewController = aBackController;
		self.frontToggleButtonImage = theFrontToggleButtonImage;
		self.backToggleButtonImage = theBackToggleButtonImage;
	}
	return self;
}

+ (DTToggleViewController *)controllerWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController 
										   backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController 
									   frontToggleButtonImage:(UIImage *)theFrontToggleButtonImage
										backToggleButtonImage:(UIImage *)theBackToggleButtonImage
{
	return [[[self alloc] initWithFrontViewController:aFrontController 
								   backViewController:aBackController
							   frontToggleButtonImage:theFrontToggleButtonImage
								backToggleButtonImage:theBackToggleButtonImage] autorelease];
}

#pragma mark Public methods

- (void)toggle {
	unless (backIsLoaded) {
		self.backViewController.view.frame = self.view.bounds;
		self.backViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backIsLoaded = YES;
	}
	
	[self.currentViewController viewWillDisappear:YES];
	[self.hiddenViewController viewWillAppear:YES];
	[self setToolbarItems:self.hiddenViewController.toolbarItems animated:YES];
	[self.navigationController showOrHideToolbarForViewController:self.hiddenViewController];
	self.hiddenViewController.view.frame = self.currentViewController.view.frame;
	
	[UIView beginAnimations:@"toggleFlip" context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	[self.view addSubview:self.hiddenViewController.view];
	[self.currentViewController.view removeFromSuperview];
	self.toggleBarButtonItem.image = backIsShowing ? frontToggleButtonImage : backToggleButtonImage;
	backIsShowing = !backIsShowing;
	
	[UIView commitAnimations];	
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if (!self.toggleBarButtonItem) {
		self.toggleBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:frontToggleButtonImage 
																	 style:UIBarButtonItemStyleBordered 
																	target:nil 
																	action:nil] autorelease];	
	}
	
	if (!self.hideToggleButton) {
		self.navigationItem.rightBarButtonItem = toggleBarButtonItem;
	}
	
	self.toggleBarButtonItem.target = self;
	self.toggleBarButtonItem.action = @selector(toggleButtonClicked:);
	
	self.frontViewController.view.frame = self.view.bounds;
	self.frontViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
	self.toolbarItems = self.frontViewController.toolbarItems; 
	[self.view addSubview:self.frontViewController.view];
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.currentViewController viewWillAppear: animated];
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.currentViewController viewDidAppear:animated];	
	[super viewDidAppear:animated]; 
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.currentViewController viewWillDisappear:animated];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.currentViewController viewDidDisappear:animated];
	[super viewWillDisappear:animated];
}

#pragma mark Dynamic properties

- (UIViewController <DTActsAsChildViewController> *)frontViewController {
	return dtFrontViewController;
}

- (void)setFrontViewController:(UIViewController <DTActsAsChildViewController>*)front
{
	self.dtFrontViewController = front;
	front.containerViewController = self;
}

- (UIViewController <DTActsAsChildViewController> *)backViewController {
	return dtBackViewController;
}

- (void)setBackViewController:(UIViewController <DTActsAsChildViewController>*)back
{
	self.dtBackViewController = back;
	back.containerViewController = self;
}

- (UIViewController <DTActsAsChildViewController>*) currentViewController {
	if (backIsShowing) return self.backViewController;
	else return self.frontViewController;
}

- (UIViewController <DTActsAsChildViewController>*) hiddenViewController {
	if (backIsShowing) return self.frontViewController;
	else return self.backViewController;
}

- (BOOL)hideToggleButton {
	return dtHideToggleButton;
}

- (void)setHideToggleButton:(BOOL)shouldHide {
	dtHideToggleButton = shouldHide;
	if (shouldHide) {
		self.navigationItem.rightBarButtonItem = nil;
	}
	else {
		self.navigationItem.rightBarButtonItem = toggleBarButtonItem;
	}
}


#pragma mark Actions

- (IBAction)toggleButtonClicked:(id)sender
{
	[self toggle];
}

#pragma mark Private methods

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.currentViewController viewDidAppear: YES];
	[self.hiddenViewController viewDidDisappear: YES];
}

//- (void)updateToolbarForHiddenControllerAnimated:(BOOL)animated {
//	if (self.hiddenViewController.toolbarItems) {
//		[self.navigationController setToolbarHidden:NO animated:animated];
//		[self setToolbarItems:self.hiddenViewController.toolbarItems animated:animated && !self.navigationController.toolbarHidden];
//	}
//	else {
//		[self.navigationController setToolbarHidden:YES animated:animated];
//	}
//	self.hiddenViewController.view.frame = self.currentViewController.view.frame;	
//}
//
//- (void)updateToolbarForCurrentControllerAnimated:(BOOL)animated {
//	if (self.currentViewController.toolbarItems) {
//		[self setToolbarItems:self.currentViewController.toolbarItems animated:animated && !self.navigationController.toolbarHidden];
//		[self.navigationController setToolbarHidden:NO animated:animated];
//	}
//	else {
//		self.toolbarItems = nil;
//		[self.navigationController setToolbarHidden:YES animated:animated];
//	}
//	self.hiddenViewController.view.frame = self.currentViewController.view.frame;
//}

@end
