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
@property (nonatomic, retain) NSMutableDictionary *activityIndicators;
- (UIWebView *)fetchOrCreateWebView;
- (void)loadPageBasedOnTagForWebView:(UIWebView *)webView;
- (void)startActivityIndicatorForWebView:(UIWebView *)webView;
- (BOOL)webViewHasContentLoaded:(UIWebView *)webView;
@end

@implementation DTPagedWebViewController
@synthesize unusedWebViews, scrollView, activityIndicators;

- (void)dealloc {
    self.unusedWebViews = nil;
    self.scrollView = nil;
    self.activityIndicators = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    self.activityIndicators = [NSMutableDictionary dictionaryWithCapacity:3];
    [super viewDidLoad];
    self.unusedWebViews = [NSMutableArray arrayWithCapacity:3];
    self.scrollView = (DTPagedScrollView *)self.view;
    if (!scrollView.dataSource) scrollView.dataSource = self;
    scrollView.numberOfPages = [self numberOfPages];
    [scrollView showPageWithIndex:[self defaultPageIndex] animated:NO];
}

- (UIView *)pagedScrollView:(DTPagedScrollView *)aScrollView viewForPageWithIndex:(NSInteger)index {
    UIWebView *webView = [self fetchOrCreateWebView];
    if ([self webViewHasContentLoaded:webView] || ![self webView:webView containsPageWithIndex:index]) {
        webView.tag = index+1;
        [self startActivityIndicatorForWebView:webView];
        [self loadContentContainingPageWithIndex:index inWebView:webView];
    }
    else {
        webView.tag = index+1;
        [self loadPageBasedOnTagForWebView:webView];
    }
    return webView;
}

- (BOOL)webViewHasContentLoaded:(UIWebView *)webView {
    return webView.tag == 0;
}

- (void)startActivityIndicatorForWebView:(UIWebView *)webView {
    NSNumber *key = [NSNumber numberWithInteger:webView.tag];
    UIActivityIndicatorView *activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    CGRect frame = activityIndicator.frame;
    CGRect pageFrame = [scrollView frameForPageIndex:webView.tag - 1];
    frame.origin.x = pageFrame.origin.x + pageFrame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = pageFrame.origin.y + pageFrame.size.height / 2 - frame.size.height / 2;
    activityIndicator.frame = frame;
    [scrollView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicators setObject:activityIndicator forKey:key];
}

- (void)stopActivityIndicatorForWebView:(UIWebView *)webView {
    NSNumber *key = [NSNumber numberWithInteger:webView.tag];
    UIActivityIndicatorView *activityIndicator = [activityIndicators objectForKey:key];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [activityIndicators removeObjectForKey:key];
}

- (void)webViewDidFinishLoadingDOM:(UIWebView *)webView {
    [self loadPageBasedOnTagForWebView:webView];
    [self stopActivityIndicatorForWebView:webView];
}

- (void)loadPageBasedOnTagForWebView:(UIWebView *)webView {
    [self presentPageWithIndex:webView.tag-1 inWebView:webView];
}

- (UIWebView *)fetchOrCreateWebView {
    UIWebView *webView = nil;
    if ([unusedWebViews count] > 0) {
        webView = [[[unusedWebViews lastObject] retain] autorelease];
        [unusedWebViews removeLastObject];
    }
    else {
        webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        webView.userInteractionEnabled = NO;
    }
    return webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // Intercept URL request starting with app: scheme to determine that the page is loaded and javascript is active.
    if ([[[request URL] scheme] isEqual:@"app"]) {
        [self webViewDidFinishLoadingDOM:webView];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)pagedScrollView:(DTPagedScrollView *)aScrollView recycleView:(UIView *)aView fromPageWithIndex:(NSInteger)index {
    [(UIWebView *)aView stringByEvaluatingJavaScriptFromString:@"prepareWebViewForReuse()"];
    // Stop any active activity indicator for this view in case this view gets reused before it finishes loading.
    [self stopActivityIndicatorForWebView:(UIWebView *)aView];
    [unusedWebViews addObject:aView];
}


- (void)pagedScrollView:(DTPagedScrollView *)pagedScrollView didSwitchToPageWithIndex:(NSInteger)index view:(UIView *)focusedView {
    [self savePageIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	[unusedWebViews removeAllObjects];
}

// Subclasses should return YES if the webView already contains the specified page.  In this case, the
// subclass should be prepared to immediately handle loadPageWithIndex:inWebView:.  If the webView doesn't
// already contain the page with the specified index, the subclass should return NO, and be prepared to
// receive reloadWebView:.
- (BOOL)webView:(UIWebView *)webView containsPageWithIndex:(NSInteger)index {
    return NO;
}

// Subclasses should implement this to show/load HTML content corresponding to the tag number on the view
- (void)loadContentContainingPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView {
}

// Subclasses should implement this to load the designated page in the webView
- (void)presentPageWithIndex:(NSInteger)index inWebView:(UIWebView *)webView {
    NSAssert(0, @"loadPageWithIndex:inWebView: must be implemented in subclass of DTPagedWebViewController.");
}

// Subclasses should implement this to return the number of pages to show
- (NSInteger)numberOfPages {
    return 0;
}

// Subclasses can implement this if they want to save the current index each time a page is turned
- (void)savePageIndex:(NSInteger)index {
}

// Subclasses can implement this if they want to open the book to some page other than 0
- (NSInteger)defaultPageIndex {
    return 0;
}


@end