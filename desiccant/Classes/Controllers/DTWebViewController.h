//
//  ACWebViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTViewController.h"
#import "ZestUtilities.h"

@protocol ACWebLinkController;

@interface DTWebViewController : DTViewController <UIWebViewDelegate> {
    NSMutableArray *dtLinkControllerChain;
    NSString *javascriptOnLoad;
	BOOL spinning;
    NSInteger spinnerDepth;
}
    
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray *linkControllerChain;
@property (nonatomic, retain) NSString *javascriptOnLoad;

+ (DTWebViewController *) webViewController;
+ (DTWebViewController *) webViewControllerWithTitle: (NSString *) title;

- (id)init;
- (id)initWithTitle:(NSString *)title;
+ (id)controller;
+ (id)controllerWithTitle:(NSString *)title;
// Subclasses should implement this to show/load HTML content as appropriate
- (void)reloadWebView;
- (void)addLinkController:(id <ACWebLinkController>)controller;
- (void)removeAllLinkControllers;
// This will get called if the webView attempts to load app://loaded.
// Set <body onload="window.location.href = 'app://loaded'"> to trigger it.
// Necessary because webViewDidFinishLoad: doesn't guarantee that the page
// is ready to process javascript.
- (void)webViewIsReadyForJavascript:(UIWebView *)loadedWebView;
// Returns YES by default.  Subclasses can return NO to suppress the spinner shown in the status bar.
- (BOOL)shouldShowSpinnerWhileLoading;
@end
