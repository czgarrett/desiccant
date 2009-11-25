//
//  ACAboutViewController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACAboutViewController : UIViewController<UIWebViewDelegate> {
   IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

- (void) reloadWebView;

@end
