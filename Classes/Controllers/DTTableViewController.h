//
//  DTTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"

@interface DTTableViewController : UITableViewController {
   IBOutlet DTCustomTableViewCell *tempCell;
   IBOutlet UIView *headerView;
   IBOutlet UIView *footerView;
}

// The .xib should set its File's Owner to DTTableViewController, and connect this cell outlet to its
// custom UITableViewCell.
@property (nonatomic, retain) IBOutlet DTCustomTableViewCell *tempCell;    
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;

// A subclass can override this if it needs to push to a navigation controller that isn't in its stack.  An example of this
// arose in the InsuranceJournal project, where the table view is displayed as a subview of a container view, which also contains 
// a UIImageView for an ad as a sibling.  In this case, the DTStaticTableViewController isn't in the nav controller's hierarchy, 
// but the the view controller for the container view is.  So in that case we need to push to the navigationController property
// of the container view's view controller.
- (UINavigationController *) navigationControllerToReceivePush;

@end
