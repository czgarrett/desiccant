//
//  DTCompositeViewController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCompositeViewController.h"
#import "Zest.h"

@interface DTCompositeViewController()
@property (nonatomic, retain) NSMutableSet *subviewControllers;
@end

@implementation DTCompositeViewController
@synthesize subviewControllers;

- (void)dealloc {
	self.subviewControllers = nil;
    [super dealloc];
}

#pragma mark UIViewController methdos

- (void)viewWillAppear:(BOOL)animated {
	for (UIViewController *controller in subviewControllers) {
		[controller viewWillAppear:animated];
	}
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	for (UIViewController *controller in subviewControllers) {
		[controller viewDidAppear:animated];
	}
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	for (UIViewController *controller in subviewControllers) {
		[controller viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	for (UIViewController *controller in subviewControllers) {
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
	if ([subviewController containerViewController] == self) {
		[subviewController setContainerViewController:nil];
	}
	[self.subviewControllers removeObject:subviewController];
}

#pragma mark Dynamic properties
	 
- (NSMutableSet *)subviewControllers {
	if (!subviewControllers) {
		self.subviewControllers = [NSMutableSet setWithCapacity:4];
	}
	return subviewControllers;
}

@end
