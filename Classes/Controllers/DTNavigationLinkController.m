//
//  DTNavigationLinkController.m
//  iWebKitHybridDemo
//
//  Created by Curtis Duhn on 2/12/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTNavigationLinkController.h"
#import "Zest.h"
#import "RegexKitLite.h"

@interface DTNavigationLinkController()
@end

@implementation DTNavigationLinkController
@synthesize webViewController, nextController;

#pragma mark Memory management

- (void)dealloc {
	self.webViewController = nil;
	self.nextController = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithWebViewController:(DTWebViewController *)theWebViewController {
	if (self = [super init]) {
		self.webViewController = theWebViewController;
	}
	return self;
}

+ (id)controllerWithWebViewController:(DTWebViewController *)theWebViewController {
	return [[[self alloc] initWithWebViewController:theWebViewController] autorelease];
}

#pragma mark ACWebLinkController protocol methods

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return ([[[request URL] absoluteString] startsWith:@"app://loaded?"] ||
			[[[request URL] absoluteString] startsWith:@"app://push/"] ||
			NO);
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSDictionary *params = [[request URL] queryParameters];
	if ([[[request URL] absoluteString] startsWith:@"app://loaded?"]) {
		if ([params stringForKey:@"title"]) {
			if (self.webViewController.navigationItem && 
				(self.webViewController.navigationItem.title == nil ||
				 [self.webViewController.navigationItem.title isEmpty])) 
			{
				self.webViewController.navigationItem.title = [params stringForKey:@"title"];
			}
		}
	}
	else if ([[[request URL] absoluteString] startsWith:@"app://push/"]) {
		NSString *back = [[[[request URL] absoluteString] stringByMatching:@"^app://push/(.*?)/" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		if (back) self.webViewController.navigationItem.backBarButtonItem = [UIBarButtonItem itemWithTitle:back];
		else self.webViewController.navigationItem.backBarButtonItem = [UIBarButtonItem itemWithTitle:@"Back"];
		NSString *title = [[[[request URL] absoluteString] stringByMatching:@"^app://push/.*?/(.*?)/" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
		NSString *urlString = [[[request URL] absoluteString] stringByMatching:@"^app://push/.*?/.*?/(.*)" capture:1];
		NSURL *nextURL = [NSURL URLWithString:urlString relativeToURL:[request URL]];
		if (self.webViewController.navigationController) {
			// TODO: get the nextController from a delegate rather than constructing one here.
			// The problem is that this new controller doesn't have any link controllers set.
			self.nextController = [DTWebViewController controllerWithTitle:title];
			[nextController.webView loadRequest:nextURL.to_request];
			[self.webViewController.navigationController pushViewController:nextController animated:YES];
			return NO;
		}
		else {
			[self.webViewController.webView loadRequest:nextURL.to_request];
			return NO;
		}
	}
	return NO;
}

@end
