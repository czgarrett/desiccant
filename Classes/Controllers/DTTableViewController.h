//
//  DTTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/27/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"
#import "DTActsAsChildViewController.h"

@interface DTTableViewController : UITableViewController <DTActsAsChildViewController> {
    IBOutlet DTCustomTableViewCell *cell;
	UIViewController *_containerViewController;
}

@property (nonatomic, retain) UITableViewController *containerTableViewController;

// The .xib should set its File's Owner to DTTableViewController, and connect this cell outlet to its
// custom UITableViewCell.
@property (nonatomic, retain) IBOutlet DTCustomTableViewCell *cell;    

// A subclass can override this if it needs to push to a navigation controller that isn't in its stack.  An example of this
// arose in the InsuranceJournal project, where the table view is displayed as a subview of a container view, which also contains 
// a UIImageView for an ad as a sibling.  In this case, the DTStaticTableViewController isn't in the nav controller's hierarchy, 
// but the the view controller for the container view is.  So in that case we need to push to the navigationController property
// of the container view's view controller.
- (UINavigationController *) navigationControllerToReceivePush;

// These methods can be used to implement logic that should be called before and after viewDidLoad, viewDid/WillAppear:, and 
// viewDid/WillDisappear:, whether the controller is being used as a top level controller, or as the child of a DTCompositeTableViewController.
// When you override these methods, bear in mind that your controller may not own the entire table.
- (void) beforeTableViewDidLoad:(UITableView *)theTableView;
- (void) afterTableViewDidLoad:(UITableView *)theTableView;
- (void) beforeTableView:(UITableView *)theTableView willAppear:(BOOL)animated;
- (void) afterTableView:(UITableView *)theTableView willAppear:(BOOL)animated;
- (void) beforeTableView:(UITableView *)theTableView didAppear:(BOOL)animated;
- (void) afterTableView:(UITableView *)theTableView didAppear:(BOOL)animated;
- (void) beforeTableView:(UITableView *)theTableView willDisappear:(BOOL)animated;
- (void) afterTableView:(UITableView *)theTableView willDisappear:(BOOL)animated;
- (void) beforeTableView:(UITableView *)theTableView didDisappear:(BOOL)animated;
- (void) afterTableView:(UITableView *)theTableView didDisappear:(BOOL)animated;

- (NSInteger)numberOfRowsAcrossAllSectionsInTableView:(UITableView*)theTableView;

@end
