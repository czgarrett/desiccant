//
//  DTRemoteWebViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTRemoteWebViewController.h"
#import "Zest.h"

@implementation DTRemoteWebViewController

@synthesize url, errorOverlayView;

- (void)dealloc {
    [url release];
    [errorOverlayView release];
    
    [super dealloc];
}

- (DTRemoteWebViewController *)init {
    return [self initWithTitle:nil url:nil];
}

- (DTRemoteWebViewController *)initWithTitle:(NSString *)newTitle url:(NSURL *)newURL {
    if (self = [super initWithTitle:newTitle]) {
        self.url = newURL;
    }
    return self;
}

+ (DTRemoteWebViewController *)controllerWithURL:(NSURL *)newURL {
    return [self controllerWithTitle:nil url:newURL];
}

+ (DTRemoteWebViewController *)controllerWithTitle:(NSString *)title url:(NSURL *)newURL {
    return [[[self alloc] initWithTitle:title url:newURL] autorelease];
}

- (void) reloadWebView {
    if (self.url) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)loadingWebView {
    [super webViewDidStartLoad:loadingWebView];
    if (errorOverlayView && errorOverlayView.superview) {
        [errorOverlayView removeFromSuperview];
    }
}

- (void)webView:(UIWebView *)loadingWebView didFailLoadWithError:(NSError *)error {
    [super webView:loadingWebView didFailLoadWithError:error];
    if (errorOverlayView) {
        [errorOverlayView overlayView:self.view];
    }
}

@end
