//
//  UINavigationController+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/25/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "UINavigationController+Zest.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (Zest)

- (NSArray *) popToViewControllerWithClass: (Class) searchClass animated: (BOOL)animated{
   return [self popToViewController: [self firstViewControllerWithClass: searchClass] animated: animated];
}

- (UIViewController *) firstViewControllerWithClass: (Class) searchClass {
   for (NSInteger i=[self.viewControllers count] - 2; i>=0; i--) {
      UIViewController *parent = (UIViewController *)[self.viewControllers objectAtIndex: i];
      if ([parent isKindOfClass: searchClass]) {
         return parent;
      }
   }
    return nil;
}

- (void)showOrHideToolbarForViewController:(UIViewController *)controller {
	controller.view = controller.view; // Force viewDidLoad on the controller
	BOOL shouldHide = (controller.toolbarItems == nil || [controller.toolbarItems count] == 0);
	self.toolbarHidden = shouldHide;
}

- (UIViewController *) rootViewController {
   return [self.viewControllers firstObject];
}

- (void) popViewControllerAnimateForward {
   CATransition *transition = [CATransition animation];
   transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
   transition.type = kCATransitionPush;
   transition.subtype = kCATransitionFromRight;
   transition.delegate = self;
   [self.view.layer addAnimation:transition forKey:nil];
   
   [self popViewControllerAnimated: NO];
}

@end


@interface FixCategoryBugUINavigationController : NSObject {}
@end
@implementation FixCategoryBugUINavigationController
@end
