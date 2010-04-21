//
//  ACAboutViewController.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ACAboutViewController.h"
#import "UITabBarItem+Zest.h"

@implementation ACAboutViewController

@synthesize webView, warnBeforeExit, requestedURL;

- (void)dealloc {
	self.webView.delegate = nil;
	self.webView = nil;
	self.requestedURL = nil;
	[super dealloc];
}

- (id) init {
	if (self = [super init]) {
		self.tabBarItem = [UITabBarItem itemNamed: @"About"];
		self.warnBeforeExit = NO;
	}
	return self;
}

- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	[self reloadWebView];
}

- (void) loadView {
	[super loadView];
	webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 480.0)];
	webView.delegate = self;
	self.view = webView;
}

- (void) reloadWebView {
   NSStringEncoding encoding;
   NSError *error;
   NSString *path = [[NSBundle mainBundle] pathForResource: @"About" ofType: @"html"];
   if (!path) {
      path = [[NSBundle mainBundle] pathForResource: @"about" ofType: @"html"]; // for backwards compatibility with previous versions of the framework
}
   NSURL *baseURL = [NSURL fileURLWithPath: path];
   NSString *fileContents = [NSString stringWithContentsOfFile: path usedEncoding: &encoding error: &error];
	[webView loadHTMLString: fileContents baseURL: baseURL];   
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	self.requestedURL = [request URL];
    if (![requestedURL isFileURL] &&
		(navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted)) {
		if (self.warnBeforeExit && [[requestedURL scheme] isEqual:@"http"]) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"External link" 
																 message:@"Exit the app and open this link in Safari?" 
																delegate:self 
													   cancelButtonTitle:@"Cancel" 
													   otherButtonTitles:@"OK", nil] autorelease];
			[alertView show];
		}
		else if (self.warnBeforeExit && [[requestedURL scheme] isEqual:@"mailto"]) {
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"External link" 
																 message:@"Exit the app compose an email to this address?" 
																delegate:self 
													   cancelButtonTitle:@"Cancel" 
													   otherButtonTitles:@"OK", nil] autorelease];
			[alertView show];
		}
		else{
			[[UIApplication sharedApplication] openURL:[request URL]];
		}
        return NO;
    }
	else {
		return YES;
	}

}

#pragma mark UIAlertViewDelegate methods
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) { // "OK"
		[[UIApplication sharedApplication] openURL:requestedURL];
	}
}


@end
