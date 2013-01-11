//
//  DTPlayMediaLinkController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 3/18/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACWebLinkController.h"

@class DTWebViewController;

@interface DTPlayMediaLinkController : NSObject <ACWebLinkController, UIWebViewDelegate> {
//	UIWebView *hiddenWebView;
	DTWebViewController *controller;
}

//@property (nonatomic, retain) UIWebView *hiddenWebView;
@property (nonatomic, retain) DTWebViewController *controller;

// Designated initializer
- (id)initWithController:(DTWebViewController *)theController;
- (id)init;
+ (id)controllerWithController:(DTWebViewController *)theController;
+ (id)controller;
- (NSURL *)mediaURLFromURLParameter:(NSURL *)appURL;

@end
