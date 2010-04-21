//
//  DTAdViewController.m
//  InsuranceJournal
//
//  Created by Curtis Duhn on 4/17/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTAdViewController.h"
#import "Zest.h"

@interface DTAdViewController()
@property (nonatomic, retain) NSObject <DTAdLoader> *dtAdLoader;
@property (nonatomic, retain) NSObject *adData;
@property (nonatomic, retain) UIView *placeholderView;
@property (nonatomic, retain) UIView *placeholderWrapperView;
@property (nonatomic, retain) UIView *placeholderSeparatorView;
@property (nonatomic, retain) UIButton *placeholderButton;
@property (nonatomic, retain) UIView *adView;
@property (nonatomic, retain) UIView *adWrapperView;
@property (nonatomic, retain) UIView *adSeparatorView;
@property (nonatomic, retain) UIButton *adButton;
- (void)setup;
- (void)showAdView:(UIView *)theAdView;
- (void)adShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)hideAdView;
- (CGRect)frameForViewControllerViewWithAdShowing;
- (CGRect)frameForViewControllerViewWithAdHidden;
- (CGRect)frameForPlaceholderWrapperView;
- (CGRect)onscreenFrameForAdWrapperView;
- (CGRect)offscreenFrameForAdWrapperView;
- (CGRect)frameForPlaceholderSeparatorView;
- (CGRect)frameForAdSeparatorView;
- (CGPoint)centerPointForPlaceholderView;
- (CGPoint)centerPointForAdView;
- (UIViewAutoresizing)autoresizingMaskForWrapperViews;
- (UIViewAutoresizing)autoresizingMaskForSeparatorViews;
@end


@implementation DTAdViewController
@synthesize viewController, dtAdLoader, adData, adAnimationDuration, placeholderView, placeholderWrapperView, marginColor, separatorColor, placeholderSeparatorView, placeholderButton, adView, adWrapperView, adSeparatorView, adButton;

#pragma mark Memory management

- (void)dealloc {
	self.viewController = nil;
	[dtAdLoader cancelLoadingAdForController:self];
	self.dtAdLoader.delegate = self;
	self.dtAdLoader = nil;
	self.adData = nil;
	self.placeholderView = nil;
	self.placeholderSeparatorView = nil;
	self.placeholderButton = nil;
	self.adView = nil;
	self.adWrapperView = nil;
	self.adSeparatorView = nil;
	self.adButton = nil;
	self.marginColor = nil;
	self.separatorColor = nil;
	[super dealloc];
}

#pragma mark Constructors

- (id)initWithViewController:(UIViewController <DTActsAsChildViewController> *)theController adLoader:(NSObject <DTAdLoader> *)theAdLoader {
	if (self = [super init]) {
		self.viewController = theController;
//		[self addSubviewController:viewController];
		self.adLoader = theAdLoader;
	}
	return self;
}

+ (id)controllerWithViewController:(UIViewController <DTActsAsChildViewController> *)theController adLoader:(NSObject <DTAdLoader> *)theAdLoader {
	return [[[self alloc] initWithViewController:theController adLoader:theAdLoader] autorelease];
}

#pragma mark NSObject

- (void)awakeFromNib {
	[super awakeFromNib];
//	[self addSubviewController:viewController];
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[self addSubviewController:viewController];
	[self setup];
	self.placeholderView = [self.adLoader tryPerformSelector:@selector(placeholderViewForAdViewController:) withObject:self];
	if (placeholderView) {
		self.placeholderWrapperView = [[[UIView alloc] initWithFrame:[self frameForPlaceholderWrapperView]] autorelease];
		placeholderWrapperView.autoresizingMask = [self autoresizingMaskForWrapperViews];
		placeholderWrapperView.backgroundColor = self.marginColor;
		[self.view addSubview:placeholderWrapperView];
		
		self.placeholderSeparatorView = [[[UIView alloc] initWithFrame:[self frameForPlaceholderSeparatorView]] autorelease];
		placeholderSeparatorView.autoresizingMask = [self autoresizingMaskForSeparatorViews];
		placeholderSeparatorView.backgroundColor = self.separatorColor;
		[placeholderWrapperView addSubview:placeholderSeparatorView];
		
		placeholderView.center = [self centerPointForPlaceholderView];
		placeholderView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
		[placeholderWrapperView addSubview:placeholderView];
		
		self.placeholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
		placeholderButton.frame = placeholderView.frame;
		placeholderButton.autoresizingMask = placeholderView.autoresizingMask;
		[placeholderButton addTarget:self action:@selector(placeholderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[placeholderWrapperView addSubview:placeholderButton];		
	}
	self.viewController.view.frame = [self frameForViewControllerViewWithAdHidden];
	self.viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if (self.viewController.view.superview) [self.viewController.view removeFromSuperview];
	[self.view addSubview:self.viewController.view];
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	if (placeholderWrapperView.superview) {
		[self.adLoader tryPerformSelector:@selector(registerPlaceholderWasDisplayedForViewController:) withObject:self];
	}
	self.adData = nil;
	self.adWrapperView = nil;
	[self.adLoader performSelectorOnMainThread:@selector(loadAdForViewController:) withObject:self waitUntilDone:NO];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self hideAdView];
	[super viewDidDisappear:animated];
}

#pragma mark DTAdLoaderDelegate methods

- (void)adLoader:(NSObject <DTAdLoader> *)loader didFinishLoadingView:(UIView *)theAdView withAdData:(NSObject *)theAdData {
	self.adData = theAdData;
	[self showAdView:theAdView];
}

#pragma mark Actions

- (void)placeholderButtonClicked {
	[self.adLoader tryPerformSelector:@selector(registerPlaceholderWasClickedForViewController:) withObject:self];
}

- (void)adButtonClicked {
	[self.adLoader tryPerformSelector:@selector(registerAdWasClickedForViewController:withAdData:) withObject:self withObject:self.adData];
}

#pragma mark Dynamic properties

- (NSObject <DTAdLoader> *)adLoader {
	return dtAdLoader;
}

- (void)setAdLoader:(NSObject <DTAdLoader> *)theAdLoader {
	[dtAdLoader cancelLoadingAdForController:self];
	dtAdLoader.delegate = nil;
	self.dtAdLoader = theAdLoader;
	dtAdLoader.delegate = self;
}

#pragma mark Private methods

- (void)setup {
	self.adAnimationDuration = 0.4f;
	self.marginColor = [UIColor whiteColor];
	self.separatorColor = [UIColor grayColor];
}

- (void)showAdView:(UIView *)theAdView {
	self.adView = theAdView;
	if (self.adView) {
		self.adWrapperView = [[[UIView alloc] initWithFrame:[self offscreenFrameForAdWrapperView]] autorelease];
		adWrapperView.autoresizingMask = [self autoresizingMaskForWrapperViews];
		adWrapperView.backgroundColor = self.marginColor;
		adWrapperView.alpha = 0.0f;
		self.view.clipsToBounds = YES;
		[self.view addSubview:adWrapperView];
		
		self.adSeparatorView = [[[UIView alloc] initWithFrame:[self frameForAdSeparatorView]] autorelease];
		adSeparatorView.autoresizingMask = [self autoresizingMaskForSeparatorViews];
		adSeparatorView.backgroundColor = self.separatorColor;
		[adWrapperView addSubview:adSeparatorView];
		
		adView.center = [self centerPointForAdView];
		adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
		[adWrapperView addSubview:adView];
		
		self.adButton = [UIButton buttonWithType:UIButtonTypeCustom];
		adButton.frame = adView.frame;
		adButton.autoresizingMask = adView.autoresizingMask;
		[adButton addTarget:self action:@selector(adButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		[adWrapperView addSubview:adButton];
		
		[UIView beginAnimations:nil context:self.view];
		[UIView setAnimationDuration:self.adAnimationDuration];
		[UIView setAnimationDidStopSelector:@selector(adShowAnimationDidStop:finished:context:)];
		[UIView setAnimationDelegate:self];
		
		adWrapperView.frame = [self onscreenFrameForAdWrapperView];
		adWrapperView.alpha = 1.0f;
		self.viewController.view.frame = [self frameForViewControllerViewWithAdShowing];
		
		[UIView commitAnimations];
	}
}

- (void)adShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.adLoader tryPerformSelector:@selector(registerAdWasDisplayedForViewController:withAdData:) withObject:self withObject:self.adData];
}

- (void)hideAdView {
	self.viewController.view.frame = [self frameForViewControllerViewWithAdHidden];
	[adWrapperView removeFromSuperview];
	self.adWrapperView = nil;
	self.adView = nil;
	self.adSeparatorView = nil;
	self.adButton = nil;
}

- (CGRect)frameForViewControllerViewWithAdShowing {
	if (adWrapperView) {
		return CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - adWrapperView.height);
	}
	else {
		return CGRectMake(0.0f, 0.0f, self.view.width, self.view.height);
	}
}

- (CGRect)frameForViewControllerViewWithAdHidden {
	if (placeholderWrapperView) {
		return CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - placeholderWrapperView.height);
	}
	else {
		return CGRectMake(0.0f, 0.0f, self.view.width, self.view.height);
	}
}

- (CGRect)frameForPlaceholderWrapperView {
	return CGRectMake(0.0f, self.view.height - placeholderView.height - 1, self.view.width, placeholderView.height + 1);
}

- (CGRect)onscreenFrameForAdWrapperView {
	return CGRectMake(0.0, self.view.height - adWrapperView.height, self.view.width, adWrapperView.height);
}

- (CGRect)offscreenFrameForAdWrapperView {
	return CGRectMake(0.0, self.view.height, self.view.width, adView.height + 1);
}

- (CGRect)frameForPlaceholderSeparatorView {
	return CGRectMake(0.0f, 0.0f, placeholderWrapperView.width, 1.0f);
}

- (CGRect)frameForAdSeparatorView {
	return CGRectMake(0.0f, 0.0f, adWrapperView.width, 1.0f);
}

- (CGPoint)centerPointForPlaceholderView {
	return CGPointMake(placeholderWrapperView.width / 2, placeholderView.height / 2 + 1);
}

- (CGPoint)centerPointForAdView {
	return CGPointMake(adWrapperView.width / 2, adView.height / 2 + 1);
}

- (UIViewAutoresizing)autoresizingMaskForWrapperViews {
	return UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
}

- (UIViewAutoresizing)autoresizingMaskForSeparatorViews {
	return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
}

@end
