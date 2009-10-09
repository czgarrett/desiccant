//
//  ACAboutViewController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACAboutViewController : UIViewController {
   IBOutlet UIWebView *webView;
}

@property (nonatomic, readonly) IBOutlet UIWebView *webView;

- (void) reloadWebView;

@end
