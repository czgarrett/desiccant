//
//  DTTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewController.h"


@implementation DTTableViewController
@synthesize tempCell, headerView, footerView, activityIndicator;

- (void)dealloc {
   self.tempCell = nil;
   self.activityIndicator = nil;
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

- (void) showBusy: (BOOL) busy {
   [self prepareActivityIndicator];
   if (activityIndicator) {
      if (busy) {
         [activityIndicator startAnimating];
      } else {
         [activityIndicator stopAnimating];
      }
   }
}

- (void)prepareActivityIndicator {
   if (!activityIndicator) {
      self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
      activityIndicator.hidesWhenStopped = YES;
      activityIndicator.center = self.view.center;
      [self.view addSubview:activityIndicator];
   }
}


@end
