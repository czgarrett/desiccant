//
//  DTRemoteWebViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTWebViewController.h"

@interface DTRemoteWebViewController : DTWebViewController {
    NSURL *url;
    UIView *errorOverlayView;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIView *errorOverlayView;

- (DTRemoteWebViewController *)initWithTitle:(NSString *)newTitle url:(NSURL *)newURL;
+ (DTRemoteWebViewController *)controllerWithURL:(NSURL *)newURL;
+ (DTRemoteWebViewController *)controllerWithTitle:(NSString *)title url:(NSURL *)newURL;

@end
