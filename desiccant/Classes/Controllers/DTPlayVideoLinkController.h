//
//  DTPlayVideoLinkController.h
//
//  Created by Curtis Duhn on 8/6/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTPlayVideoLinkController : NSObject {
	UIViewController *controller;
}

@property (nonatomic, retain) UIViewController *controller;

- (id)initWithController:(UIViewController *)theController;
+ (id)controllerWithController:(UIViewController *)theController;

@end
