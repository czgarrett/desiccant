//
//  ACWebViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTWebViewController.h"
#import "DTSpinner.h"

@interface DTWebViewController()
@property (nonatomic, retain) NSMutableArray *dtLinkControllerChain;
@end

@implementation DTWebViewController

@synthesize dtLinkControllerChain, javascriptOnLoad;

+ (DTWebViewController *) webViewController {
   return [[[DTWebViewController alloc] init] autorelease];
}

+ (DTWebViewController *) webViewControllerWithTitle: (NSString *) title {
   return [[[DTWebViewController alloc] initWithTitle: title] autorelease];   
}


- (void)dealloc {
	self.dtLinkControllerChain = nil;
	self.javascriptOnLoad = nil;
	self.webView.delegate = nil;
	self.view = nil;
    
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

+ (id)controller {
	return [[[self alloc] init] autorelease];
}

+ (id)controllerWithTitle:(NSString *)title {
	return [[[self alloc] initWithTitle:title] autorelease];
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (spinning) {
		spinning = NO;
		[DTSpinner hide];
	}
}

// Subclasses should implement this to show/load HTML content as appropriate
- (void) reloadWebView {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)webView:(UIWebView *)specifiedWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL continueProcessing = YES;
	if ([request.URL.absoluteString isEqual:@"app://loaded"]) {
		[self webViewIsReadyForJavascript:specifiedWebView];
	}
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

- (void)removeAllLinkControllers {
	[self.linkControllerChain removeAllObjects];
}

- (void)webViewIsReadyForJavascript:(UIWebView *)loadedWebView {
    if (javascriptOnLoad) {
        [self.webView stringByEvaluatingJavaScriptFromString:javascriptOnLoad];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)loadingWebView {
	if (loadingWebView.request && ![loadingWebView.request.URL isFileURL]) {
		[DTSpinner show];
		spinning = YES;
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)loadingWebView {
	if (spinning) {
		[DTSpinner hide];
		spinning = NO;
	}
}

- (void)webView:(UIWebView *)loadingWebView didFailLoadWithError:(NSError *)error {
	if (spinning) {
		[DTSpinner hide];
		spinning = NO;
	}
}

- (NSMutableArray *)linkControllerChain {
	if (!dtLinkControllerChain) self.dtLinkControllerChain = [NSMutableArray arrayWithCapacity:2];
	return dtLinkControllerChain;
}

- (void)setLinkControllerChain:(NSMutableArray *)theChain {
	self.dtLinkControllerChain = theChain; 
}

- (UIWebView *)webView {
	return (UIWebView *)self.view;
}

- (void)setWebView:(UIWebView *)theWebView {
	self.view = theWebView;
}

@end
