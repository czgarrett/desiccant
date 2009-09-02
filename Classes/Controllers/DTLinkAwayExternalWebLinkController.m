//
//  DTLinkAwayExternalWebLinkController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTLinkAwayExternalWebLinkController.h"


@implementation DTLinkAwayExternalWebLinkController

- (id) init {
    if (self = [super init]) {
    }
    return self;
}

+ (DTLinkAwayExternalWebLinkController *)controller {
    return [[[self alloc] init] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    else {
        return YES;
    }
}

@end
