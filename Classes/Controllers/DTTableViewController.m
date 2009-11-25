//
//  DTTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewController.h"

@interface DTTableViewController()
@property (nonatomic, retain) UIViewController *_containerViewController;
@end

@implementation DTTableViewController
@synthesize cell, _containerViewController;

- (void)dealloc {
	self.cell = nil;
	self._containerViewController = nil;

	[super dealloc];
}

- (void)setContainerViewController:(UIViewController *)theController {
	self._containerViewController = theController;
}

- (UIViewController *)containerViewController {
	return _containerViewController;
}

- (void)setContainerTableViewController:(UITableViewController *)theController {
	self._containerViewController = theController;
}

- (UITableViewController *)containerTableViewController {
	if ([_containerViewController isKindOfClass:[UITableViewController class]]) {
		return (UITableViewController *)_containerViewController;
	}
	else {
		return nil;
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

- (void) viewDidLoad {
	[self beforeTableViewDidLoad:self.tableView];
	[super viewDidLoad];
	[self afterTableViewDidLoad:self.tableView];
}

- (void) viewWillAppear:(BOOL)animated {
	[self beforeTableView:self.tableView willAppear:animated];
	[super viewWillAppear:animated];
	[self afterTableView:self.tableView willAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[self beforeTableView:self.tableView didAppear:animated];
	[super viewDidAppear:animated];
	[self afterTableView:self.tableView didAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[self beforeTableView:self.tableView willDisappear:animated];
	[super viewWillDisappear:animated];
	[self afterTableView:self.tableView willDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	[self beforeTableView:self.tableView didDisappear:animated];
	[super viewDidDisappear:animated];
	[self afterTableView:self.tableView didDisappear:animated];
}

- (void) beforeTableViewDidLoad:(UITableView *)theTableView {}
- (void) afterTableViewDidLoad:(UITableView *)theTableView {}
- (void) beforeTableView:(UITableView *)theTableView willAppear:(BOOL)animated {}
- (void) afterTableView:(UITableView *)theTableView willAppear:(BOOL)animated {}
- (void) beforeTableView:(UITableView *)theTableView didAppear:(BOOL)animated {}
- (void) afterTableView:(UITableView *)theTableView didAppear:(BOOL)animated {}
- (void) beforeTableView:(UITableView *)theTableView willDisappear:(BOOL)animated {}
- (void) afterTableView:(UITableView *)theTableView willDisappear:(BOOL)animated {}
- (void) beforeTableView:(UITableView *)theTableView didDisappear:(BOOL)animated {}
- (void) afterTableView:(UITableView *)theTableView didDisappear:(BOOL)animated {}

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


- (NSInteger)numberOfRowsAcrossAllSectionsInTableView:(UITableView*)theTableView  {
	NSInteger numberOfRows = 0;
	for (NSInteger section = 0; section < [self numberOfSectionsInTableView:theTableView]; section++) {
		numberOfRows += [self tableView:theTableView numberOfRowsInSection:section];
	}
	return numberOfRows;
}


@end
