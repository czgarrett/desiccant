//
//  DTNavigationController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 2/6/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTNavigationController.h"
#import "Zest.h"

@interface DTNavigationController()
@end

@implementation DTNavigationController

//- (void)dealloc {
//    [super dealloc];
//}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
	if ([self.viewControllers count] > 1) {
		[self.topViewController willPopOffOfNavigationStack];
		[self.topViewController.previousControllerInNavigationStack controllerWillPopOffOfNavigationStack:self.topViewController];
		
		UIViewController *controllerBeingPopped = [super popViewControllerAnimated:animated];
		
		[controllerBeingPopped didPopOffOfNavigationStack];		
		[self.topViewController controllerDidPopOffOfNavigationStack:controllerBeingPopped];
		
		return controllerBeingPopped;
	}
	else {
		return nil;
	}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[viewController willGetPushedOntoNavigationStack];
	[self.topViewController controllerWillGetPushedOntoNavigationStack:viewController];
	
	[super pushViewController:viewController animated:(BOOL)animated];
	
	[self.topViewController didGetPushedOntoNavigationStack];
	[self.topViewController.previousControllerInNavigationStack controllerDidGetPushedOntoNavigationStack:self.topViewController];
}


@end
