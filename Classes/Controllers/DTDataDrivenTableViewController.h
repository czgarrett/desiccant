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

@property (nonatomic, retain)  DTAsyncQuery * query;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIWebView *mediaWebView;
@property (nonatomic, retain) NSString *moreResultsCellNibName;
@property (nonatomic, retain) NSString *moreResultsCellIdentifier;

@end
