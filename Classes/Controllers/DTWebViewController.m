//
//  ACWebViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTWebViewController.h"
#import "DTSpinner.h"


@implementation DTWebViewController

@synthesize webView, linkControllerChain, javascriptOnLoad;

- (void)dealloc {
    [webView release];
    [linkControllerChain release];
    [javascriptOnLoad release];
    
    [super dealloc];
}

- (id)init {
    return [self initWithTitle:nil];
}

- (id)initWithTitle:(NSString *)title {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.linkControllerChain = [NSMutableArray array];
        self.navigationItem.title = title;
        self.javascriptOnLoad = nil;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view = [[[UIWebView alloc] init] autorelease];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = (UIWebView *)self.view;
    self.webView.delegate = self;
}

- (void) viewWillAppear: (BOOL) animated {
    [self reloadWebView];
}

// Subclasses should implement this to show/load HTML content as appropriate
- (void) reloadWebView {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)webView:(UIWebView *)specifiedWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL continueProcessing = YES;
    for (int i=0; i < [self.linkControllerChain count]; i++) {
        if ([(id <ACWebLinkController>)[self.linkControllerChain objectAtIndex:i] canHandleRequest:request navigationType:navigationType]) {
            continueProcessing = continueProcessing && [(id <ACWebLinkController>)[self.linkControllerChain objectAtIndex:i] handleRequest:request navigationType:navigationType];
        }
        if (!continueProcessing) break;
    }
    return continueProcessing;
}

- (void)addLinkController:(id <ACWebLinkController>)controller {
    [self.linkControllerChain addObject:controller];
}

- (void)webViewDidStartLoad:(UIWebView *)loadingWebView {
    [DTSpinner show];
}

- (void)webViewDidFinishLoad:(UIWebView *)loadingWebView {
    [DTSpinner hide];
    if (javascriptOnLoad) {
        [self.webView stringByEvaluatingJavaScriptFromString:javascriptOnLoad];
    }
}

- (void)webView:(UIWebView *)loadingWebView didFailLoadWithError:(NSError *)error {
    [DTSpinner hide];
}

@end
