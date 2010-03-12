//
//  DTTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewController.h"
#import "Zest.h"

@interface DTTableViewController()
@property (nonatomic, assign) UIViewController *dtContainerViewController;
@property (nonatomic, retain) UIView *dtWindowOverlay;
@property (nonatomic, retain) DTActivityIndicatorView *dtActivityIndicator;
@end

@implementation DTTableViewController
@synthesize tempCell, headerView, footerView, dtContainerViewController, dtWindowOverlay, shouldAutorotateToPortrait, shouldAutorotateToLandscape, shouldAutorotateUpsideDown, dtActivityIndicator;

#pragma mark Memory management
- (void)dealloc {
	self.tempCell = nil;
	self.dtContainerViewController = nil;
	self.dtWindowOverlay = nil;
	self.dtActivityIndicator = nil;

	[super dealloc];
}

- (void) viewDidLoad {
   [super viewDidLoad];
   [self.tableView setTableFooterView: footerView];
   [self.tableView setTableHeaderView: headerView];
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
	self.dtContainerViewController = theController;
}

- (UIViewController *)containerViewController {
	return dtContainerViewController;
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

- (void) viewWillAppear:(BOOL)animated {
	if (!self.containerViewController) [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (indexPath) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (UITableView *)tableView {
	if (self.containerTableViewController) {
		return self.containerTableViewController.tableView;
	}
	else {
		return super.tableView;
	}
}

- (UIView *)view {
	if (self.containerTableViewController) {
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
   if (!dtActivityIndicator) {
      dtActivityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
      dtActivityIndicator.hidesWhenStopped = YES;
      dtActivityIndicator.center = self.view.center;
      [self.view addSubview:dtActivityIndicator];
   }
}


@end
