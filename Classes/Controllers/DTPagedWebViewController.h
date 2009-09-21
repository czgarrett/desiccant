//
//  DTPagedWebViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTPagedScrollViewDataSource.h"

@interface DTPagedWebViewController : UIViewController <UIScrollViewDelegate, DTPagedScrollViewDataSource, UIWebViewDelegate> {
    NSMutableArray *unusedWebViews;
    DTPagedScrollView *scrollView;
    BOOL didSetNumberOfPages;
}

@property (nonatomic, retain) DTPagedScrollView *scrollView;

// Subclasses should implement this to show/load HTML content as appropriate
- (void)reloadWebView:(UIWebView *)webView;
// Subclasses should implement this to load the designated page in the webView
- (void)loadPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView;
// Subclasses should implement this to return the number of pages to show
- (NSInteger)numberOfPages;
// Subclasses can implement this if they want to save the current index each time a page is turned
- (void)savePageIndex:(NSInteger)index;
// Subclasses can implement this if they want to open the book to some page other than 0
- (NSInteger)defaultPageIndex;

@end
