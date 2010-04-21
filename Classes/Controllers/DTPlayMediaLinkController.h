//
//  DTPlayMediaLinkController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 3/18/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACWebLinkController.h"

@interface DTPlayMediaLinkController : NSObject <ACWebLinkController> {
	UIWebView *hiddenWebView;
}

@property (nonatomic, retain) UIWebView *hiddenWebView;
+ (id)controller;

@end
