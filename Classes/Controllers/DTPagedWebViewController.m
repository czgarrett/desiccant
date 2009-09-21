//
//  DTPagedWebViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTPagedWebViewController.h"

@interface DTPagedWebViewController()
@property (nonatomic, retain) NSMutableArray *unusedWebViews;
- (UIWebView *)fetchWebView;
@end

@implementation DTPagedWebViewController
@synthesize unusedWebViews, scrollView;

- (void)dealloc {
    self.unusedWebViews = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    didSetNumberOfPages = NO;
    self.scrollView = (DTPagedScrollView *)self.view;
    if (!scrollView.dataSource) scrollView.dataSource = self;
    [scrollView showPageWithIndex:[self defaultPageIndex] animated:NO];
}

- (NSInteger)defaultPageIndex {
    return 0;
}

- (UIView *)pagedScrollView:(DTPagedScrollView *)aScrollView viewForPageWithIndex:(NSInteger)index {
    UIWebView *webView = [self fetchWebView];
    NSLog(@"Setting webView tag for index: %d", index);
    webView.tag = index+1;
    return webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"*** Got webViewDidFinishLoad for webView with tag: %d", webView.tag);
    [self loadPageWithIndex:webView.tag-1 inWebView:webView];
    if (!didSetNumberOfPages && webView == [[self scrollView] focusedView]) {
        NSLog(@"!!! Setting number of pages based on focused view.");
        scrollView.numberOfPages = [self numberOfPages];
        didSetNumberOfPages = YES;
    }
}

- (void)loadPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView {
}


- (UIWebView *)fetchWebView {
    UIWebView *webView = nil;
    if ([unusedWebViews count] > 0) {
        webView = [unusedWebViews lastObject];
        [unusedWebViews removeLastObject];
        [webView reload];
    }
    else {
        webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        webView.delegate = self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self reloadWebView:webView];
    }
    return webView;
}

- (void)pagedScrollView:(DTPagedScrollView *)aScrollView recycleView:(UIView *)aView fromPageWithIndex:(NSInteger)index {
    [unusedWebViews addObject:aView];
}

- (NSInteger)numberOfPages {
    return 0;
}

- (void)pagedScrollView:(DTPagedScrollView *)pagedScrollView didSwitchToPageWithIndex:(NSInteger)index view:(UIView *)focusedView {
    [self savePageIndex:index];
}

- (void)savePageIndex:(NSInteger)index {
}

- (void)reloadWebView:(UIWebView *)webView {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

	[unusedWebViews removeAllObjects];
}

@end