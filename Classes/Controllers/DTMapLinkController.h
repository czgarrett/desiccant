//
//  DTMapLinkController.h
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTMapLinkControllerDelegate.h"
#import "ACWebLinkController.h"

@interface DTMapLinkController : NSObject <ACWebLinkController> {
    id <DTMapLinkControllerDelegate> delegate;
}

@property (nonatomic, assign) id <DTMapLinkControllerDelegate> delegate;

- (id)initWithDelegate:(id <DTMapLinkControllerDelegate>)theDelegate;
+ (id)controllerWithDelegate:(id <DTMapLinkControllerDelegate>)theDelegate;

@end
