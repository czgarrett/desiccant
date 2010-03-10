//
//  ACWebViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebLinkController.h"

@interface DTWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
    NSMutableArray *linkControllerChain;
    NSString *javascriptOnLoad;
}
    
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray *linkControllerChain;
@property (nonatomic, retain) NSString *javascriptOnLoad;

+ (DTWebViewController *) webViewController;
+ (DTWebViewController *) webViewControllerWithTitle: (NSString *) title;

- (id)init;
- (id)initWithTitle:(NSString *)title;
// Subclasses should implement this to show/load HTML content as appropriate
- (void)reloadWebView;
- (void)addLinkController:(id <ACWebLinkController>)controller;

@end
