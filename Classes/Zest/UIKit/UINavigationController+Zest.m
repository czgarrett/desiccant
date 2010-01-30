//
//  UINavigationController+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/25/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "UINavigationController+Zest.h"


@implementation UINavigationController (Zest)

- (void) popToViewControllerWithClass: (Class) searchClass animated: (BOOL)animated{
   [self popToViewController: [self firstViewControllerWithClass: searchClass] animated: animated];
}

- (UIViewController *) firstViewControllerWithClass: (Class) searchClass {
   for (int i=[self.viewControllers count] - 2; i>=0; i--) {
      UIViewController *parent = (UIViewController *)[self.viewControllers objectAtIndex: i];
      if ([parent isKindOfClass: searchClass]) {
         return parent;
      }
   }
   return (UIViewController *)[self.viewControllers objectAtIndex: 0];
}

- (void)showOrHideToolbarForViewController:(UIViewController *)controller {
	controller.view = controller.view; // Force viewDidLoad on the controller
	BOOL shouldHide = (controller.toolbarItems == nil || [controller.toolbarItems count] == 0);
	self.toolbarHidden = shouldHide;
}

@end
