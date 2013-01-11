//
//  DTTabBarController.m
//  BlueDevils
//
//  Created by Curtis Duhn on 2/19/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTTabBarController.h"
#import "Zest.h"
#import "DTActivityIndicatorView.h"

@interface DTTabBarController()
@property (nonatomic, assign) id <UITabBarControllerDelegate> secondaryDelegate;
@property (nonatomic, retain) UIView *dtWindowOverlay;
@property (nonatomic, retain) DTActivityIndicatorView *dtActivityIndicator;
- (void)restorePersistedIndex;
- (void)persistIndex:(NSInteger)theIndex;
@end

@implementation DTTabBarController
@synthesize persistSelectedIndex, secondaryDelegate, shouldFadeDefaultPNG, dtWindowOverlay, dtActivityIndicator;

- (void)dealloc {
	self.secondaryDelegate = nil;
	super.delegate = nil;
	self.dtWindowOverlay = nil;
	self.dtActivityIndicator = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		persistSelectedIndex = YES;
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		persistSelectedIndex = YES;
	}
	return self;
}

- (id)init {
	if ((self = [super init])) {
		persistSelectedIndex = YES;
	}
	return self;
}

#pragma mark Public methods

- (void)fadeWindowOverlay {
	if (self.windowOverlay) {
		[UIView beginAnimations:@"WindowOverlayFadeAnimation" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self.windowOverlay];
		[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
		self.windowOverlay.alpha = 0.0;
		[UIView commitAnimations];
	}
}


#pragma mark Dynamic properties

- (void)setWindowOverlay:(UIView *)theView {
	self.dtWindowOverlay = theView;
    if ([[[[UIApplication sharedApplication] keyWindow] subviews] count] >= 1) {
        self.dtWindowOverlay.transform = [(UIView *)[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] transform];
    }
	theView.center = [[UIScreen mainScreen] center];
	[[[UIApplication sharedApplication] keyWindow] addSubview:theView];
}

- (UIView *)windowOverlay {
	return self.dtWindowOverlay;
}

- (DTActivityIndicatorView *)activityIndicator {
	unless (dtActivityIndicator) {
		self.dtActivityIndicator = [[[DTActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		dtActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	}
	unless (dtActivityIndicator.superview) {
		dtActivityIndicator.hidesWhenStopped = YES;
		dtActivityIndicator.center = self.view.center;
		[self.view.superview addSubview:dtActivityIndicator];
	}
	
	return self.dtActivityIndicator;
}

#pragma mark UIViewController methods
- (void)viewDidLoad {
	if (super.delegate != self) self.secondaryDelegate = super.delegate;
	super.delegate = self;
	[super viewDidLoad];
	if (persistSelectedIndex) [self restorePersistedIndex];
	if (self.shouldFadeDefaultPNG) self.windowOverlay = [UIImageView defaultPNGView];
}

- (void)viewDidAppear:(BOOL)animated {
	if (self.windowOverlay) [self.windowOverlay.superview bringSubviewToFront:self.windowOverlay];
	[super viewDidAppear:animated];
	if (self.shouldFadeDefaultPNG) [self fadeWindowOverlay];
}

- (void)presentModalViewController:(UIViewController *)theViewController animated:(BOOL)animated {
    if ([theViewController respondsToSelector:@selector(setModalPresenter:)]) {
        [theViewController performSelector:@selector(setModalPresenter:) withObject:self];
    }
    
    if ([theViewController respondsToSelector:@selector(viewControllerToPresentModally)]) {
        UIViewController *wrapper = [theViewController performSelector:@selector(viewControllerToPresentModally)];
        if ([wrapper respondsToSelector:@selector(setModalPresenter:)]) {
            [wrapper performSelector:@selector(setModalPresenter:) withObject:self];
        }
        [super presentModalViewController:wrapper animated:animated];
    }
    else {
        [super presentModalViewController:theViewController animated:animated];
    }
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
