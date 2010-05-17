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
#import "DTActivityIndicatorView.h"

@interface DTTableViewController : UITableViewController <DTActsAsChildViewController> {
   IBOutlet UIView *headerView;
   IBOutlet UIView *footerView;
   IBOutlet DTCustomTableViewCell *cell;
	UIViewController *dtContainerViewController;
	UIView *dtWindowOverlay;
	BOOL shouldAutorotateToPortrait;
	BOOL shouldAutorotateToLandscape;
	BOOL shouldAutorotateUpsideDown;
	BOOL hasAppeared;
	DTActivityIndicatorView *dtActivityIndicator;
}

@property (nonatomic, assign) UIViewController *containerViewController;
// Returns the top of this nested controller hierarchy, or self if controller has
// no container.
@property (nonatomic, assign, readonly) UIViewController *topContainerViewController;
@property (nonatomic, retain) UITableViewController *containerTableViewController;

// The .xib should set its File's Owner to DTTableViewController, and connect this cell outlet to its
// custom UITableViewCell.
@property (nonatomic, retain) IBOutlet DTCustomTableViewCell *cell;    
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, retain) UIView *windowOverlay;
@property (nonatomic) BOOL shouldAutorotateToPortrait;
@property (nonatomic) BOOL shouldAutorotateToLandscape;
@property (nonatomic) BOOL shouldAutorotateUpsideDown;
@property (nonatomic) BOOL hasAppeared;
@property (nonatomic, retain, readonly) DTActivityIndicatorView *activityIndicator;

// Called before the first viewWillAppear:
- (void)viewWillFirstAppear:(BOOL)animated;

// Called before the first viewDidAppear:
- (void)viewDidFirstAppear:(BOOL)animated;

- (void)fadeWindowOverlay;

// Subclasses can override this and set the three shouldAutorotate* properties to allow autorotation
- (void)setAutorotationProperties;

// A subclass can override this if it needs to push to a navigation controller that isn't in its stack.  An example of this
// arose in the InsuranceJournal project, where the table view is displayed as a subview of a container view, which also contains 
// a UIImageView for an ad as a sibling.  In this case, the DTStaticTableViewController isn't in the nav controller's hierarchy, 
// but the the view controller for the container view is.  So in that case we need to push to the navigationController property
// of the container view's view controller.
- (UINavigationController *) navigationControllerToReceivePush;

// Hides or shows the activity indicator if present
- (void) showBusy: (BOOL) busy;
- (void)prepareActivityIndicator;

// These methods can be used to implement logic that should be called before and after viewDidLoad, viewDid/WillAppear:, and 
// viewDid/WillDisappear:, whether the controller is being used as a top level controller, or as the child of a DTCompositeTableViewController.
// When you override these methods, bear in mind that your controller may not own the entire table.
//- (void) beforeViewDidLoad:(UIView *)theTableView;
//- (void) afterViewDidLoad:(UIView *)theTableView;
//- (void) beforeView:(UIView *)theTableView willAppear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView willAppear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView didAppear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView didAppear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView willDisappear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView willDisappear:(BOOL)animated;
//- (void) beforeView:(UIView *)theTableView didDisappear:(BOOL)animated;
//- (void) afterView:(UIView *)theTableView didDisappear:(BOOL)animated;

- (NSInteger)numberOfRowsAcrossAllSectionsInTableView:(UITableView*)theTableView;


@end
