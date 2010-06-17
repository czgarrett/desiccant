//
//  DTAdViewController.h
//
//  Created by Curtis Duhn on 4/17/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCompositeViewController.h"
#import "DTViewController.h"

@class DTAdViewController;
@protocol DTAdLoaderDelegate;

@protocol DTAdLoader <NSObject>
@property (nonatomic, assign) id <DTAdLoaderDelegate> delegate;

// Loader must start loading an ad when this is called, and call the delegate's
// adLoader:didFinishLoadingView:withAdData: when the ad is ready.
- (void)loadAdForViewController:(DTAdViewController *)controller;

// When this is called, the loader should cancel any ads that are loading for 
// the specified controller, and should not call 
// adLoader:didFinishLoadingView:withAdData:.
- (void)cancelLoadingAdForController:(DTAdViewController *)controller;


@optional

// Return a placeholder view to present in place of the ad while the ad is loading.
// Return nil if you don't want to use a placeholder view, in which case, the
// adViewController's viewController will fill the whole screen until the ad is
// loaded and presented.  If not implemented, or if it returns nil,
// no placeholder will be displayed.
- (UIView *)placeholderViewForAdViewController:(DTAdViewController *)controller;

// Called when the placeholder is displayed.  Loader may use this opportunity to notify
// the ad server that the placeholder was displayed.
- (void)registerPlaceholderWasDisplayedForViewController:(DTAdViewController *)controller;

// Called when the ad is displayed.  Loader may use this opportunity to notify
// the ad server that the ad was displayed.
- (void)registerAdWasDisplayedForViewController:(DTAdViewController *)controller withAdData:(NSObject *)theAdData;

// Called when the placeholder was clicked. Loader may use this opportunity to
// notify the ad server that the placeholder was clicked and/or may load a view or
// web site in response to the click.
- (void)registerPlaceholderWasClickedForViewController:(DTAdViewController *)controller;

// Called when the ad was clicked. Loader may use this opportunity to
// notify the ad server that the ad was clicked and/or may load a view or
// web site in response to the click.
- (void)registerAdWasClickedForViewController:(DTAdViewController *)controller withAdData:(NSObject *)theAdData;
@end

@protocol DTAdLoaderDelegate <NSObject>
// Loader must call this when the ad is loaded and ready for display.  adData
// will be passed back to the registerAd* loader methods.
- (void)adLoader:(id <DTAdLoader>)loader didFinishLoadingView:(UIView *)theAdView withAdData:(NSObject *)theAdData;
@end

@interface DTAdViewController : DTCompositeViewController <DTAdLoaderDelegate> {
	UIViewController <DTActsAsChildViewController> *viewController;
	NSObject <DTAdLoader> *dtAdLoader;
	NSObject *adData;
	NSTimeInterval adAnimationDuration;
	UIView *placeholderView;
	UIView *placeholderWrapperView;
	UIView *placeholderSeparatorView;
	UIButton *placeholderButton;
	UIView *adView;
	UIView *adWrapperView;
	UIView *adSeparatorView;
	UIButton *adButton;	
	
	UIColor *marginColor;
	UIColor *separatorColor;
	NSDate *loadStartTime;
}

@property (nonatomic, retain) IBOutlet UIViewController <DTActsAsChildViewController> *viewController;
@property (nonatomic, retain) IBOutlet NSObject <DTAdLoader> * adLoader;
@property (nonatomic, assign) NSTimeInterval adAnimationDuration;
@property (nonatomic, retain) UIColor *marginColor;
@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, retain) NSDate *loadStartTime;

- (id)initWithViewController:(UIViewController <DTActsAsChildViewController> *)theController adLoader:(NSObject <DTAdLoader> *)theAdLoader;
+ (id)controllerWithViewController:(UIViewController <DTActsAsChildViewController> *)theController adLoader:(NSObject <DTAdLoader> *)theAdLoader;
// Subclasses may override this to define a delay before the ad should be shown.
// Defaults to 0.0.
- (NSTimeInterval) adDisplayDelayInterval;
	
@end
