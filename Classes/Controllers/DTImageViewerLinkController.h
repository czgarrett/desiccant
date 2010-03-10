//
//  DTImageViewerLinkController.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"


@interface DTImageViewerLinkController : NSObject <ACWebLinkController> {
    NSString *title;
    UIViewController *parentController;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIViewController *parentController;

- (id)initWithTitle:(NSString *)aTitle parentController:(UIViewController *)theParentController;
+ (DTImageViewerLinkController *)controllerWithTitle:(NSString *)aTitle parentController:(UIViewController *)theParentController;

@end
