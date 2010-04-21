//
//  DTPlayMediaLinkController.m
//  BlueDevils
//
//  Created by Curtis Duhn on 3/18/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTPlayMediaLinkController.h"
#import "Zest.h"

@interface DTPlayMediaLinkController()
- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL;
@end

@implementation DTPlayMediaLinkController
@synthesize hiddenWebView;

- (void)dealloc {
	self.hiddenWebView = nil;
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
		self.hiddenWebView = [[[UIWebView alloc] init] autorelease];
	}
	return self;
}

+ (id)controller {
	return [[[self alloc] init] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return [self mediaURLFromURLParameter:[request URL]] != nil;
}

// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURLRequest *newRequest = [NSURLRequest requestWithURL:[self mediaURLFromURLParameter:[request URL]]];
	[hiddenWebView loadRequest:newRequest];
	return NO;
}

- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL {
	return [[[appURL queryParameters] stringForKey:@"url"] to_url];
}


@end
