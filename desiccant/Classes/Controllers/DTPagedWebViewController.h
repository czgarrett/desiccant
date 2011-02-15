//
//  DTPagedWebViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTPagedScrollViewDataSource.h"

@interface DTPagedWebViewController : UIViewController <UIScrollViewDelegate, DTPagedScrollViewDataSource, UIWebViewDelegate> {
    NSMutableArray *unusedWebViews;
    DTPagedScrollView *scrollView;
    NSMutableDictionary *activityIndicators;
}

@property (nonatomic, retain) DTPagedScrollView *scrollView;

// Subclasses should return YES if the webView already contains the specified page.  In this case, the
// subclass should be prepared to immediately handle loadPageWithIndex:inWebView:.  If the webView doesn't
// already contain the page with the specified index, the subclass should return NO, and be prepared to
// receive reloadWebView:.
- (BOOL)webView:(UIWebView *)webView containsPageWithIndex:(NSInteger)index;
// Subclasses should implement this to show/load HTML content corresponding to the tag number on the view
- (void)loadContentContainingPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView;
// Subclasses should implement this to load the designated page in the webView
- (void)presentPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView;
// Subclasses should implement this to return the number of pages to show
- (NSInteger)numberOfPages;
// Subclasses can implement this if they want to save the current index each time a page is turned
- (void)savePageIndex:(NSInteger)index;
// Subclasses can implement this if they want to open the book to some page other than 0
- (NSInteger)defaultPageIndex;

@end
