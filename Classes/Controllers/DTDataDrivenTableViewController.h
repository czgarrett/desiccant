//
//  DTDataDrivenTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "desiccant.h"
#import "DTCustomTableViewController.h"
#import "DTAsyncQueryDelegate.h"

@interface DTDataDrivenTableViewController : DTCustomTableViewController <DTAsyncQueryDelegate, UIWebViewDelegate> {
    DTAsyncQuery * query;
    NSUInteger headerRows;
    UITableViewCell *prototype;
    UIActivityIndicatorView *activityIndicator;
    UIWebView *mediaWebView;
}

// Subclasses can implement this to display a detail view for the associated data
- (UIViewController *)detailViewControllerFor:(NSMutableDictionary *)data;
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
- (void)showErrorForFailedQuery:(DTAsyncQuery *)feed;
// Subclasses may want to implement this to hide any visible error message once the query succeeds.  Does nothing by default.
- (void)hideErrorForFailedQuery;
- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath;
- (BOOL)hasHeaders;
- (NSInteger)adjustSectionForHeaders:(NSInteger)section;
- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath;

@property (nonatomic, retain)  DTAsyncQuery * query;
@property (nonatomic) NSUInteger headerRows;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIWebView *mediaWebView;

@end
