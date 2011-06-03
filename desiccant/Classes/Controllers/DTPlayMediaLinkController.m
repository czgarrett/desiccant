//
//  DTPlayMediaLinkController.m
//  BlueDevils
//
//  Created by Curtis Duhn on 3/18/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTPlayMediaLinkController.h"
#import "Zest.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DTPlayMediaLinkController()
@end

@implementation DTPlayMediaLinkController
@synthesize controller;

- (void)dealloc {
//	hiddenWebView.delegate = nil;
//	self.hiddenWebView = nil;
	self.controller = nil;
    [super dealloc];
}

- (id)initWithController:(DTWebViewController *)theController {
	if ((self = [super init])) {
		self.controller = theController;
//		self.hiddenWebView = [[[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	}
	return self;
}

- (id)init {
	return [self initWithController:nil];
}

+ (id)controllerWithController:(DTWebViewController *)theController {
	return [[[self alloc] initWithController:theController] autorelease];
}

+ (id)controller {
	return [[[self alloc] init] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return [self mediaURLFromURLParameter:[request URL]] != nil;
}

// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	[controller.activityIndicator startAnimating];
//	NSURLRequest *newRequest = [NSURLRequest requestWithURL:[self mediaURLFromURLParameter:[request URL]]];
//	hiddenWebView.delegate = self;
//	[hiddenWebView loadRequest:newRequest];
    NSURL *url = [self mediaURLFromURLParameter:[request URL]];
    MPMoviePlayerViewController *playerViewController = [[[MPMoviePlayerViewController alloc] initWithContentURL:url] autorelease];
    if ([playerViewController.moviePlayer respondsToSelector:@selector(allowsAirPlay)]) playerViewController.moviePlayer.allowsAirPlay = YES;
    [self.controller presentMoviePlayerViewControllerAnimated:playerViewController];
    
	return NO;
}

- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL {
	return [[[appURL queryParameters] stringForKey:@"url"] to_url];
}

//#pragma mark UIWebViewDelegate methods
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	[controller.activityIndicator stopAnimating];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//	[controller.activityIndicator stopAnimating];
//}

@end
