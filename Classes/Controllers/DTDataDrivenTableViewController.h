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
    UITableViewCell *prototype;
    UIActivityIndicatorView *activityIndicator;
    UIWebView *mediaWebView;
}

// Subclasses can implement this to display a detail view for the associated data
- (UIViewController *)detailViewControllerFor:(NSMutableDictionary *)data;
// Subclasses can implement this to stream audio or video from a URL for the associated data
- (NSURL *)mediaURLFor:(NSMutableDictionary *)data;
- (void)showErrorForFailedQuery:(DTAsyncQuery *)feed;
// Subclasses may want to implement this to hide any visible error message once the query succeeds.  Does nothing by default.
- (void)hideErrorForFailedQuery;

// Subclasses can implement this to override the default UIAlertView display when media fails to load.
//- (void)displayMediaLoadError:(NSError *)error;
- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath;
- (BOOL)hasHeaders;
- (NSInteger)adjustSectionForHeaders:(NSInteger)section;
- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath;

@property (nonatomic, retain)  DTAsyncQuery * query;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIWebView *mediaWebView;

@end
