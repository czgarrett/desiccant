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

@synthesize webView;

- (id) init {
   if (self = [super init]) {
      self.tabBarItem = [UITabBarItem itemNamed: @"About"];      
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
   NSString *fileContents = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"About" ofType: @"html"] usedEncoding:&encoding error:&error];
   [webView loadHTMLString: fileContents baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];   
}

- (void)dealloc {
   self.webView.delegate = nil;
   self.webView = nil;
   [super dealloc];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == 5)
		return YES;
	
	[[UIApplication sharedApplication] openURL:[request URL]]; 
	return NO;
}

@end
