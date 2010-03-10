//
//  DTTabBarController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 2/19/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTTabBarController : UITabBarController <UITabBarControllerDelegate> {
	id <UITabBarControllerDelegate> secondaryDelegate;
	BOOL persistSelectedIndex;
}

@property (nonatomic) BOOL persistSelectedIndex;

@end
