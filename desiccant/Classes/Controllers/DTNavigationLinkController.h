//
//  DTNavigationLinkController.h
//  iWebKitHybridDemo
//
//  Created by Curtis Duhn on 2/12/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACWebLinkController.h"

@class DTWebViewController;

@interface DTNavigationLinkController : NSObject <ACWebLinkController> {
	DTWebViewController *webViewController;
	DTWebViewController *nextController;
}

@property (nonatomic, assign) DTWebViewController *webViewController;
@property (nonatomic, retain) DTWebViewController *nextController;

- (id)initWithWebViewController:(DTWebViewController *)theWebViewController;
+ (id)controllerWithWebViewController:(DTWebViewController *)theWebViewController;

@end
