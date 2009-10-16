//
//  DTMapLinkController.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"


@interface DTMapLinkController : NSObject <ACWebLinkController> {
    UIViewController *parentController;
}

@property (nonatomic, retain) UIViewController *parentController;

- (id)initWithParentController:(UIViewController *)theParentController;
+ (DTMapLinkController *)controllerWithParentController:(UIViewController *)theParentController;

@end
