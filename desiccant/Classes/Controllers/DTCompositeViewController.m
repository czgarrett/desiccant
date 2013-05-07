//
//  DTCompositeViewController.m
//
//  Created by Curtis Duhn on 12/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCompositeViewController.h"
#import "Zest.h"

@interface DTCompositeViewController()

@end

@implementation DTCompositeViewController


- (void)dealloc {
	NSArray *controllers = [_subviewControllers allObjects];
	[_subviewControllers removeAllObjects];
	for (UIViewController <DTActsAsChildViewController> *child in controllers) {
		child.containerViewController = nil;
	}
}

#pragma mark UIViewController methdos

- (void)viewWillAppear:(BOOL)animated {
	for (UIViewController *controller in _subviewControllers) {
		[controller viewWillAppear:animated];
	}
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	for (UIViewController *controller in _subviewControllers) {
		[controller viewDidAppear:animated];
	}
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	for (UIViewController *controller in _subviewControllers) {
		[controller viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	for (UIViewController *controller in _subviewControllers) {
		[controller viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}

#pragma mark Public methods

- (void)addSubviewController:(id <DTActsAsChildViewController>)subviewController {
	unless ([self.subviewControllers containsObject:subviewController]) {
		[self.subviewControllers addObject:subviewController];
		[subviewController setContainerViewController:self];
	}
}

- (void)removeSubviewController:(id <DTActsAsChildViewController>)subviewController {
	if ([self.subviewControllers containsObject:subviewController]) {
		[self.subviewControllers removeObject:subviewController];
		if ([subviewController containerViewController] == self) {
			[subviewController setContainerViewController:nil];
		}
	}
}

#pragma mark Dynamic properties
	 
- (NSMutableSet *)subviewControllers {
	if (!_subviewControllers) {
		self.subviewControllers = [NSMutableSet setWithCapacity:4];
	}
	return _subviewControllers;
}

@end
