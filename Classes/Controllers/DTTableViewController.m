//
//  DTTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewController.h"
#import "Zest.h"
#import "DTCompositeViewController.h"

@interface DTTableViewController()
@property (nonatomic, assign) UIViewController *dtContainerViewController;
@property (nonatomic, retain) UIView *dtWindowOverlay;
@property (nonatomic, retain) DTActivityIndicatorView *dtActivityIndicator;
@end

@implementation DTTableViewController
@synthesize hasAppeared, cell, headerView, footerView, dtContainerViewController, dtWindowOverlay, shouldAutorotateToPortrait, shouldAutorotateToLandscape, shouldAutorotateUpsideDown, dtActivityIndicator,
shouldAdjustViewOnKeyboardShow;

#pragma mark Memory management
- (void)dealloc {
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver: self];
	self.cell = nil;
	self.dtContainerViewController = nil;
	self.dtWindowOverlay = nil;
	self.dtActivityIndicator = nil;
	self.headerView = nil;
	self.footerView = nil;

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

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self setAutorotationProperties];
	}
	return self;
}

#pragma mark Keyboard show/hide

-(void) keyboardWillShow:(NSNotification *) notif
{
   if (!keyboardVisible) {
      NSDictionary* info = [notif userInfo];
      NSValue *rectValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
      CGSize keyboardSize = [rectValue CGRectValue].size;
      CGRect viewFrame = self.view.frame;
      // Basically this code is to handle the case when a tableview is inside a tab bar controller - it determines the bottom of the
      // frame in window coordinates and adjusts upward based on that.  Otherwise you end up with a blank
      // space below the table view when it moves up.
      CGRect frameInWindow =[self.view convertRect: viewFrame toView: nil];
      CGFloat bottom = frameInWindow.origin.y + frameInWindow.size.height;
      CGRect windowFrame = [UIApplication sharedApplication].keyWindow.frame;
      keyboardAdjustment =  -keyboardSize.height + windowFrame.size.height - bottom;
      viewFrame.size.height = viewFrame.size.height + keyboardAdjustment;
      [UIView beginAnimations: @"keyboardResize" context: nil];
         self.view.frame = viewFrame;
      [UIView commitAnimations];
      keyboardVisible = YES;      
   }
}

-(void) keyboardWillHide: (NSNotification *)notif {
	if (keyboardVisible) {
      CGRect viewFrame = [self tableView].frame;
      viewFrame.size.height -= keyboardAdjustment;
      [UIView beginAnimations: @"keyboardResize" context: nil];
         [self tableView].frame = viewFrame;
      [UIView commitAnimations];
      keyboardVisible = NO;      
	}   
}


#pragma mark UIViewController methods

- (void) viewDidUnload {
   [super viewDidUnload];
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver: self];
}

- (void) viewDidLoad {
   [super viewDidLoad];
   [self.tableView setTableFooterView: footerView];
   [self.tableView setTableHeaderView: headerView];
   keyboardAdjustment = 0.0;
   if (self.shouldAdjustViewOnKeyboardShow) {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
      [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
   }
}

// A subclass can override this if it needs to push to a navigation controller that isn't in its stack.  An example of this
// arose in the InsuranceJournal project, where the table view is displayed as a subview of a container view, which also contains 
// a UIImageView for an ad as a sibling.  In this case, the DTStaticTableViewController isn't in the nav controller's hierarchy, 
// but the the view controller for the container view is.  So in that case we need to push to the navigationController property
// of the container view's view controller.
- (UINavigationController *) navigationControllerToReceivePush {
    return self.navigationController;
}

- (NSInteger)numberOfRowsAcrossAllSectionsInTableView:(UITableView*)theTableView  {
	NSInteger numberOfRows = 0;
	for (NSInteger section = 0; section < [self numberOfSectionsInTableView:theTableView]; section++) {
		numberOfRows += [self tableView:theTableView numberOfRowsInSection:section];
	}
	return numberOfRows;
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

#pragma mark Public methods

- (void)viewWillFirstAppear:(BOOL)animated {
}

- (void)viewDidFirstAppear:(BOOL)animated {
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

- (void)setContainerTableViewController:(UITableViewController *)theController {
	self.dtContainerViewController = theController;
}

- (UITableViewController *)containerTableViewController {
	if ([dtContainerViewController isKindOfClass:[UITableViewController class]]) {
		return (UITableViewController *)dtContainerViewController;
	}
	else {
		return nil;
	}
}

#pragma mark UITableViewController methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// When self is the root view controller (or one of its nested controllers), but isn't currently visible, 
	// this allows the controller that is visible to autorotate to orientations that this controller may not support.
	// Necessary because UITabBarController returns the logical AND of its viewControllers' responses, and
	// UINavigationController returns the response of its root viewController.
	if (self.tabBarController && 
		self.tabBarController.selectedViewController  != [self topContainerViewController] && 
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

- (void) viewWillAppear:(BOOL)animated {
	unless (self.hasAppeared) [self viewWillFirstAppear:animated];
	if (!self.containerViewController) [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (indexPath) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	unless (self.hasAppeared) {
		self.hasAppeared = YES;
		[self viewDidFirstAppear:animated];
	}
	if (!self.containerViewController) [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	if (!self.containerViewController) [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	if (!self.containerViewController) [super viewDidDisappear:animated];
}

- (UINavigationController *)navigationController {
	if ([self.containerViewController respondsToSelector:@selector(navigationController)]) {
		return self.containerViewController.navigationController;
	}
	else {
		return super.navigationController;
	}
}

- (UINavigationItem *)navigationItem {
	if ([self.containerViewController respondsToSelector:@selector(navigationItem)]) {
		return self.containerViewController.navigationItem;
	}
	else {
		return super.navigationItem;
	}
}

- (UIViewController *)parentViewController {
	if ([self.containerViewController respondsToSelector:@selector(parentViewController)]) {
		return self.containerViewController.parentViewController;
	}
	else {
		return super.parentViewController;
	}
}

- (UITableView *)tableView {
	if ([self.containerTableViewController respondsToSelector:@selector(tableView)]) {
		return self.containerTableViewController.tableView;
	}
	else {
		return super.tableView;
	}
}

- (UIView *)view {
	if ([self.containerTableViewController respondsToSelector:@selector(view)]) {
		return self.containerTableViewController.view;
	}
	else {
		return super.view;
	}
}



- (void) showBusy: (BOOL) busy {
   [self prepareActivityIndicator];
   if (self.activityIndicator) {
      if (busy) {
         [self.activityIndicator startAnimating];
      } else {
         [self.activityIndicator stopAnimating];
      }
   }
}

- (void)prepareActivityIndicator {
//   if (!dtActivityIndicator) {
//      dtActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
//      dtActivityIndicator.hidesWhenStopped = YES;
//      dtActivityIndicator.center = self.view.center;
//      [self.view addSubview:dtActivityIndicator];
//   }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.tableView reloadData];
}



@end
