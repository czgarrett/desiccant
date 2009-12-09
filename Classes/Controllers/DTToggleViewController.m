//
//  DTToggleViewController.m
//  iRevealMaui
//
//  Created by Ilan Volow on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DTToggleViewController.h"

@interface DTToggleViewController()
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end


@implementation DTToggleViewController

@synthesize frontViewController;
@synthesize backViewController;
@synthesize navButtonImage;

- init
{
	if(self = [super init])
	{
		self.navButtonImage = [UIImage imageNamed:@"map.png"];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:self.navButtonImage 
                                                                                   style:UIBarButtonItemStyleBordered 
                                                                                  target:self 
                                                                                  action:@selector(toggleViews:)] autorelease];
		backIsShowing = NO;
	}
	
	return self;
}

// Note: the below setter property overrides are to automatically tie the setting of toggleview controller with the relevant properties
- (void)setFrontViewController:(UIViewController <DTActsAsChildViewController>*)front
{
	[frontViewController autorelease];
	
	frontViewController = [front retain];
	
	front.containerViewController = self;
}

- (void)setBackViewController:(UIViewController <DTActsAsChildViewController>*)back
{
	[backViewController autorelease];
	
	backViewController = [back retain];
	
	back.containerViewController = self;
}

- (UIViewController <DTActsAsChildViewController>*) currentViewController {
	if (backIsShowing) return backViewController;
	else return frontViewController;
}

- (UIViewController <DTActsAsChildViewController>*) hiddenViewController {
	if (backIsShowing) return frontViewController;
	else return backViewController;
}

// + (DTToggleViewController *)controllerWithFrontViewController:(UIViewController <DTToggleViewControllerItem>*)aFrontController backViewController:(UIViewController <DTToggleViewControllerItem> *)aBackController;
+ (DTToggleViewController *)controllerWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController

{
	DTToggleViewController *toggleController = [[[DTToggleViewController alloc] init] autorelease];
	
	toggleController.frontViewController = aFrontController;
	toggleController.backViewController = aBackController;	
		
	return toggleController;	
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = self.frontViewController.view;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];
	
    if ([currentViewController respondsToSelector:aSelector])
        [invocation invokeWithTarget:currentViewController];
    else
        [self doesNotRecognizeSelector:aSelector];
}
 */
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
/*
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
*/


- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.frontViewController viewDidLoad];
	[self.backViewController viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.currentViewController viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.currentViewController viewDidAppear:animated];
}

- (IBAction)toggleViews:(id)sender
{
	[self.hiddenViewController viewWillAppear:YES];

	[UIView beginAnimations:@"toggleFlip" context:nil];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.currentViewController.view.superview cache:NO];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[self.currentViewController.view.superview addSubview:self.hiddenViewController.view];
	[self.currentViewController.view removeFromSuperview];
	self.view = self.hiddenViewController.view;
	backIsShowing = !backIsShowing;
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.currentViewController viewDidAppear: YES];
}

- (void)dealloc {
	self.frontViewController = nil;
	self.backViewController = nil;
	
    [super dealloc];
}


@end
