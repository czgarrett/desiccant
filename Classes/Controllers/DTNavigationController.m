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
- (UIViewController *)notifyOfPopsToPoppee:(UIViewController *)poppee;
@end

@implementation DTNavigationController

//- (void)dealloc {
//    [super dealloc];
//}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
	if ([self.viewControllers count] > 1) {
		UIViewController *poppee = [self.viewControllers objectAtIndex:0];
		
		UIViewController *child = [self notifyOfPopsToPoppee:poppee];		
		NSArray *controllersBeingPopped = [super popToRootViewControllerAnimated:animated];
		
		[child didPopOffOfNavigationStack];
		[poppee controllerDidPopOffOfNavigationStack:child];
		
		return controllersBeingPopped;
	}
	else {
		return nil;
	}
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if ([self.viewControllers count] > 1) {
		UIViewController *poppee = viewController;
		
		UIViewController *child = [self notifyOfPopsToPoppee:poppee];		
		NSArray *controllersBeingPopped = [super popToViewController:viewController animated:animated];
		
		[child didPopOffOfNavigationStack];
		[poppee controllerDidPopOffOfNavigationStack:child];
		
		return controllersBeingPopped;
	}
	else {
		return [NSArray array];
	}
}

- (NSArray *)popToViewControllerWithClass:(Class)searchClass animated:(BOOL)animated {
	if ([self.viewControllers count] > 1) {
		UIViewController *poppee = [self firstViewControllerWithClass:searchClass];
		if (poppee) {
			return [self popToViewController:poppee animated:YES];
		}
		else {
			return [NSArray array];
		}
	}
	else {
		return [NSArray array];
	}	
}

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

#pragma mark Private methods

- (UIViewController *)notifyOfPopsToPoppee:(UIViewController *)poppee {
	UIViewController *popper = self.topViewController;
	UIViewController *child = popper;
	UIViewController *parent = child.previousControllerInNavigationStack;
	while (parent != poppee) {
		[child willPopOffOfNavigationStack];
		[parent controllerWillPopOffOfNavigationStack:child];
		[child didPopOffOfNavigationStack];
		[parent controllerDidPopOffOfNavigationStack:child];
		child = parent;
		parent = child.previousControllerInNavigationStack;
	}
	
	[child willPopOffOfNavigationStack];
	[parent controllerWillPopOffOfNavigationStack:child];
	
	return child;
}

@end
