//
//  DTTabBarController.m
//  BlueDevils
//
//  Created by Curtis Duhn on 2/19/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTTabBarController.h"
#import "Zest.h"

@interface DTTabBarController()
@property (nonatomic, assign) id <UITabBarControllerDelegate> secondaryDelegate;
- (void)restorePersistedIndex;
- (void)persistIndex:(NSInteger)theIndex;
@end

@implementation DTTabBarController
@synthesize persistSelectedIndex, secondaryDelegate;

- (void)dealloc {
	self.secondaryDelegate = nil;
	super.delegate = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		persistSelectedIndex = YES;
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		persistSelectedIndex = YES;
	}
	return self;
}

- (id)init {
	if (self = [super init]) {
		persistSelectedIndex = YES;
	}
	return self;
}


#pragma mark UIViewController methods
- (void)viewDidLoad {
	if (super.delegate != self) self.secondaryDelegate = super.delegate;
	super.delegate = self;
	[super viewDidLoad];
	if (persistSelectedIndex) [self restorePersistedIndex];
}

#pragma mark UITabBarController methods
-(void)setDelegate:(id <UITabBarControllerDelegate>)theDelegate {
	self.secondaryDelegate = theDelegate;
}

//-(id <UITabBarControllerDelegate>)delegate {
//	return self.secondaryDelegate;
//}

#pragma mark DTTabBarController methods

- (void)setSelectedIndex:(NSUInteger)theIndex {
	super.selectedIndex = theIndex;
	if (persistSelectedIndex) [self persistIndex:[self selectedIndex]];
}

#pragma mark UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	BOOL shouldSelect = YES;
	if (secondaryDelegate && [secondaryDelegate respondsToSelector:$(tabBarController:shouldSelectViewController:)]) {
		shouldSelect = [secondaryDelegate tabBarController:tabBarController shouldSelectViewController:viewController];
	}	
	
	if (shouldSelect && persistSelectedIndex) [self persistIndex:[self.viewControllers indexOfObject:viewController]];
	
	return shouldSelect;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	if (secondaryDelegate && [secondaryDelegate respondsToSelector:$(tabBarController:didSelectViewController:)]) {
		[secondaryDelegate tabBarController:tabBarController didSelectViewController:viewController];
	}	
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
	if (secondaryDelegate && [secondaryDelegate respondsToSelector:$(tabBarController:willBeginCustomizingViewControllers:)]) {
		[secondaryDelegate tabBarController:tabBarController willBeginCustomizingViewControllers:viewControllers];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	if (secondaryDelegate && [secondaryDelegate respondsToSelector:$(tabBarController:willEndCustomizingViewControllers:changed:)]) {
		[secondaryDelegate tabBarController:tabBarController willEndCustomizingViewControllers:viewControllers changed:changed];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	if (secondaryDelegate && [secondaryDelegate respondsToSelector:$(tabBarController:didEndCustomizingViewControllers:changed:)]) {
		[secondaryDelegate tabBarController:tabBarController didEndCustomizingViewControllers:viewControllers changed:changed];
	}	
}


#pragma mark Private methods

- (void)persistIndex:(NSInteger)theIndex {
	[[NSUserDefaults standardUserDefaults] setInteger:theIndex forKey:@"selectedViewControllerIndex"];
}

- (void)restorePersistedIndex {
	super.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedViewControllerIndex"];
}

@end
