//
//  DTPlayVideoLinkController.m
//
//  Created by Curtis Duhn on 8/6/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTPlayVideoLinkController.h"
#import "zest.h"
#import "DTMoviePlayerViewController.h"

@interface DTPlayVideoLinkController()
- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL;
@end

@implementation DTPlayVideoLinkController
@synthesize controller;

- (void)dealloc {
	self.controller = nil;
    [super dealloc];
}

- (id)initWithController:(UIViewController *)theController {
	if (self = [super init]) {
		self.controller = theController;
	}
	return self;
}

+ (id)controllerWithController:(UIViewController *)theController {
	return [[[self alloc] initWithController:theController] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return ([[request URL].to_s startsWith:@"app://video?url="] && [self mediaURLFromURLParameter:[request URL]] != nil);
}

// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	[controller presentModalViewController:[DTMoviePlayerViewController controllerWithURL:[self mediaURLFromURLParameter:[request URL]]] 
								  animated:YES];
	return NO;
}

- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL {
	return [[[appURL queryParameters] stringForKey:@"url"] to_url];
}

@end
