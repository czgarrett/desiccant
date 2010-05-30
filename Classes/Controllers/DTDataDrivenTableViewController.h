//
//  DTDataDrivenTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewController.h"
#import "DTAsyncQuery.h"

@interface DTDataDrivenTableViewController : DTCustomTableViewController <DTAsyncQueryDelegate, UIWebViewDelegate> {
    DTAsyncQuery * query;
    DTCustomTableViewCell *prototype;
	UITableViewCell *dtPrototypeMoreResultsCell;
//    UIActivityIndicatorView *activityIndicator;
    UIWebView *mediaWebView;
	NSString *moreResultsCellNibName;    
    NSString *moreResultsCellIdentifier;    
	UITableViewCell *dtNoResultsCell;
}

// Subclasses can implement this to display a detail view for the associated data
- (UIViewController *)detailViewControllerFor:(NSDictionary *)data;
// Subclasses can implement this to stream audio or video from a URL for the associated data
- (NSURL *)mediaURLFor:(NSMutableDictionary *)data;
// Subclasses can implement this to change the look & feel of any cell.  This is only called if cellNibName is not set. 
- (void)customizeCell;
// Subclasses must implement this to return a header cell if headerRows > 0
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to override the default header row height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderRowAtIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to override the default data cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForDataRowAtIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to display an error when the query fails.  Does nothing by default.
- (void)showErrorForFailedQuery:(DTAsyncQuery *)theQuery;
// Subclasses may want to implement this to hide any visible error message once the query succeeds.  Does nothing by default.
- (void)hideErrorForFailedQuery;

// Subclasses can implement this to override the default UIAlertView display when media fails to load.
//- (void)displayMediaLoadError:(NSError *)error;
- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath;
- (BOOL)indexPathIsMoreResultsCell:(NSIndexPath *)indexPath;
// Subclasses can override this to return a custom subclass of DTCustomTableViewCell with retain count 0 (autoreleased)
// for displaying the "More results" cell.  This is only called if moreResultsCellNibName is not set.
- (DTCustomTableViewCell *)constructMoreResultsCell;
// Subclasses can implement this to change the look & feel of the "More results..." cell.  This is only called if moreResultsCellNibName is not set. 
- (void)customizeMoreResultsCell;
// Subclasses can implement this to return a custom cell row height for the "More results" cell.
- (CGFloat)moreResultsCellRowHeight;
- (BOOL)hasHeaders;
- (NSInteger)adjustSectionForHeaders:(NSInteger)section;
- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath;

// Sets the noResultsCell property to a cell containing the specified message.
- (void)setNoResultsCellWithMessage:(NSString *)message;

// If this is set to YES, and the query returns no results, the controller
// will call noResultsCell and display the cell it returns.  By default, 
// this method returns YES if noResultsCell is non-nil, and NO otherwise.
- (BOOL)hasNoResultsCell;

// If hasNoResultsCell returns YES, and the query returns no results, the 
// controller will call this method to get the height for the noResultsCell.
// By default, this method calls noResultsCell and returns the height of the
// cell it returns.  Subclasses may want to override this method if they've
// overridden noResultsCell to return a dynamic cell.
- (CGFloat)heightForNoResultsCell;

// If hasNoResultsCell returns YES, and the query returns no results, the controller
// will check this property and display the cell if it is non-nil.  You may set
// this property via code or a NIB, or you may override it in a subclass and return
// something dynamic.  Bear in mind, however, that the default implementations of
// hasNoResultsCell and heightForNoResultsCell also look at this property, so if you
// override this to make it dynamic, you may want to override those methods to prevent
// this method from getting called multiple times.  If you don't need a custom
// visual design for this cell, consider using setNoResultsCellWithMessage:.
@property (nonatomic, retain) IBOutlet UITableViewCell *noResultsCell;

@property (nonatomic, retain)  DTAsyncQuery * query;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIWebView *mediaWebView;
@property (nonatomic, retain) NSString *moreResultsCellNibName;
@property (nonatomic, retain) NSString *moreResultsCellIdentifier;


@end
