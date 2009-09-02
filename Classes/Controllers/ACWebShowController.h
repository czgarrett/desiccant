//
//  ACWebShowController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 10/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACShowController.h"
#import "ACWebLinkController.h"

@interface ACWebShowController : ACShowController <UIWebViewDelegate> {
   UIWebView *webView;
   NSMutableArray *linkControllerChain;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray *linkControllerChain;

- (NSString *) toHTML;
- (void) reloadWebView;
- (void)addLinkController:(id <ACWebLinkController>)controller;

@end
