//
//  ACAboutViewController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTViewController.h"

@interface ACAboutViewController : DTViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	BOOL warnBeforeExit;
	NSURL *requestedURL;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic) BOOL warnBeforeExit;
@property (nonatomic, retain) NSURL *requestedURL;
- (void) reloadWebView;

@end
