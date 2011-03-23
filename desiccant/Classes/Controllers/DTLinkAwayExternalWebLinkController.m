//
//  DTLinkAwayExternalWebLinkController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTLinkAwayExternalWebLinkController.h"

@implementation DTLinkAwayExternalWebLinkController
@synthesize warnBeforeExit, requestedURL;

- (void)dealloc {
	self.requestedURL = nil;
	
	[super dealloc];
}

- (id) init {
    if ((self = [super init])) {
		self.warnBeforeExit = YES;
    }
    return self;
}

+ (DTLinkAwayExternalWebLinkController *)controller {
    return [[[self alloc] init] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return (navigationType == UIWebViewNavigationTypeLinkClicked ||
			navigationType == UIWebViewNavigationTypeFormSubmitted);
}

// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	self.requestedURL = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted) {
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
