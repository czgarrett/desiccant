//
//  DTModalNavigationController.h
//  desiccant
//
//  Created by Curtis Duhn on 5/6/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTNavigationController.h"

@interface DTModalNavigationController : DTNavigationController {
    
}

- (id)initWithRootViewController:(UIViewController *)rootViewController;
+ (id)controllerWithRootViewController:(UIViewController *)rootViewController;

@end
