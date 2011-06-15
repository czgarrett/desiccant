//
//  DTSlideshowView.m
//
//  Created by Curtis Duhn on 12/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSlideshowView.h"
#import "Zest.h"

static const CGFloat kDefaultMaxZoomFactor = 1.25;

@interface DTSlideshowView()
- (NSInteger)nextIndexAfter:(NSInteger)index;
- (void)startImageTransition;
- (void)startDriftAnimation;
- (void)startDecelerateAnimation;
- (void)startFadeAnimation;
- (void)startAccelerateAnimation;
- (IBAction)overlayButtonClicked;
- (void)addOverlayButton;
- (CGRect)frameForDisclosureImageView;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger nextIndex;
@property (nonatomic) NSInteger numberOfImages;
@property (nonatomic) DTSlideshowViewState state;
@property (nonatomic, retain) UIImage *currentImage;
@property (nonatomic, retain) UIImage *nextImage;
@property (nonatomic, retain) UIImageView *currentImageView;
@property (nonatomic, retain) UIImageView *nextImageView;
@property (nonatomic, retain) DTSlideshowPan *currentPan;
@property (nonatomic, retain) DTSlideshowPan *nextPan;
@property (nonatomic, retain) UIButton *overlayButton;
@property (nonatomic, retain) UIImage *dtDisclosureImage;
@property (nonatomic, retain) UIImageView *disclosureImageView;
@end

@implementation DTSlideshowView
@synthesize currentIndex, nextIndex, numberOfImages, state, currentImage, nextImage, currentImageView, nextImageView;
@synthesize currentPan, nextPan, dataSource, delegate, secondsPerTransition, secondsBetweenTransitions, maxZoomFactor;
@synthesize overlayButton, dtDisclosureImage, disclosureImageView;

- (void)dealloc {
	self.currentImage = nil;
	self.nextImage = nil;
	self.currentImageView = nil;
	self.nextImageView = nil;
	self.currentPan = nil;
	self.nextPan = nil;
	self.dataSource = nil;
	self.delegate = nil;
	self.overlayButton = nil;
	self.dtDisclosureImage = nil;
	self.disclosureImageView = nil;

    [super dealloc];
}

#pragma mark Public methods

- (void)start {
	if (state == DTSlideshowViewStateStopped || state == DTSlideshowViewStateRestarting) {
		NSAssert (state == DTSlideshowViewStateStopped || state == DTSlideshowViewStateRestarting, @"Start called on a slideshow that was already started");
		ifResponds(delegate, @selector(slideshowViewWillStartAnimating:),
				   [delegate slideshowViewWillStartAnimating:self]);
		if (secondsPerTransition == 0) {
			secondsPerTransition = 1.5;
		}
		if (secondsBetweenTransitions == 0) {
			secondsBetweenTransitions = 8;
		}
		if (maxZoomFactor < 1.0) {
			maxZoomFactor = kDefaultMaxZoomFactor;
		}
		
		self.clipsToBounds = YES;
		self.numberOfImages = [dataSource numberOfImagesInSlideshowView:self];
		nextIndex = currentIndex;
		self.nextImage = nil;
		self.currentImage = nil;
		self.nextImageView = nil;
		self.currentImageView = nil;
		self.currentPan = nil;
		self.nextPan = nil;
		state = DTSlideshowViewStateWaitingForFirstImage;
		[dataSource slideshowView:self requestsImageAtIndex:nextIndex];
	}
	else if (state == DTSlideshowViewStateStopping) {
		state = DTSlideshowViewStateRestarting;
	}
}

- (void)stop {
	if (state == DTSlideshowViewStateStopped) {
	}
	else if (state == DTSlideshowViewStateWaitingForFirstImage) {
		state = DTSlideshowViewStateStopping;
		ifResponds(delegate, @selector(slideshowViewWillStopAnimating:),
				   [delegate slideshowViewWillStopAnimating:self]);
		state = DTSlideshowViewStateStopped;
		ifResponds(delegate, @selector(slideshowViewDidStopAnimating:),
				   [delegate slideshowViewDidStopAnimating:self]);
	}
	else if (state == DTSlideshowViewStateAnimating) {
		state = DTSlideshowViewStateStopping;
		ifResponds(delegate, @selector(slideshowViewWillStopAnimating:),
				   [delegate slideshowViewWillStopAnimating:self]);
	}
	else if (state == DTSlideshowViewStateRestarting) {
		state = DTSlideshowViewStateStopping;
	}
	else { // state == DTSlideshowViewStateStopping
	}
}

- (void)setImage:(UIImage *)image forIndex:(NSInteger)index {
	if ((state == DTSlideshowViewStateWaitingForFirstImage || 
		 state == DTSlideshowViewStateAnimating) && 
		nextImage == nil &&
		nextIndex == index) 
	{
		self.nextImage = image;
		self.nextImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
		
		if (state == DTSlideshowViewStateWaitingForFirstImage) {
			state = DTSlideshowViewStateAnimating;
			ifResponds(delegate, @selector(slideshowViewDidStopAnimating:),
					   [delegate slideshowViewDidStartAnimating:self]);
			self.nextPan = [DTSlideshowPan randomPanWithSecondsPerTransition:secondsPerTransition 
												   secondsBetweenTransitions:secondsBetweenTransitions];
			ifResponds(delegate, @selector(slideshowView:willDisplayImageAtIndex:),
					   [delegate slideshowView:self willDisplayImageAtIndex:nextIndex]);
			[self startImageTransition];
			[self addOverlayButton];
		}
		else {			
		}
	}
}

- (void)skipImageWithIndex:(NSInteger)index {
	if ((state == DTSlideshowViewStateWaitingForFirstImage || 
		 state == DTSlideshowViewStateAnimating) && 
		nextImage == nil &&
		nextIndex == index)
	{
		nextIndex = [self nextIndexAfter:nextIndex];
		[dataSource slideshowView:self requestsImageAtIndex:nextIndex];
	}
}

#pragma mark Dynamic properties

- (UIImage *)disclosureImage {
	return dtDisclosureImage;
}

- (void)setDisclosureImage:(UIImage *)theImage {
	self.dtDisclosureImage = theImage;
	if (disclosureImageView.superview) [disclosureImageView removeFromSuperview];
	if (theImage) {
		self.disclosureImageView = [UIImageView viewWithImage:theImage];
		disclosureImageView.frame = [self frameForDisclosureImageView];
		disclosureImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		disclosureImageView.userInteractionEnabled = NO;
		if (overlayButton.superview) {
			[self addSubview:disclosureImageView];
		}
	}
	else {
		self.disclosureImageView = nil;
	}
}


#pragma mark Actions

- (IBAction)overlayButtonClicked {
	ifResponds(delegate, @selector(slideshowView:willSelectImageAtIndex:), 
			   [delegate slideshowView:self willSelectImageAtIndex:currentIndex]);
	ifResponds(delegate, @selector(slideshowView:didSelectImageAtIndex:), 
			   [delegate slideshowView:self didSelectImageAtIndex:currentIndex]);
}


#pragma mark Private methods

- (void)startImageTransition {
	nextImageView.frame = [nextPan frameAtStartOfPanForImage:nextImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	nextImageView.alpha = 0.0;
	
	[UIView beginAnimations:@"Slideshow" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:secondsPerTransition];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(imageTransitionDidFinish)];	
	
	nextImageView.frame = [nextPan frameAtStartOfDriftForImage:nextImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	nextImageView.alpha = 1.0;
	[self addSubview:nextImageView];
	[self bringSubviewToFront:self.overlayButton];
	if (disclosureImageView) [self bringSubviewToFront:disclosureImageView];
	
	if (currentImage) {
		currentImageView.frame = [currentPan frameAtEndOfPanForImage:currentImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
		currentImageView.alpha = 0.0;
	}
	
	[UIView commitAnimations];
}

- (void)imageTransitionDidFinish {
	[currentImageView removeFromSuperview];
	currentIndex = nextIndex;
	nextIndex = [self nextIndexAfter:currentIndex];
	self.currentImage = nextImage;
	self.nextImage = nil;
	self.currentImageView = nextImageView;
	self.nextImageView = nil;
	self.currentPan = nextPan;
	self.nextPan = nil;
	
	ifResponds(delegate, @selector(slideshowView:didDisplayImageAtIndex:), 
			   [delegate slideshowView:self didDisplayImageAtIndex:currentIndex]);
	[self startDriftAnimation];
	[dataSource slideshowView:self requestsImageAtIndex:nextIndex];
}

- (void)startDriftAnimation {
	[UIView beginAnimations:@"Slideshow" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:secondsBetweenTransitions];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(driftAnimationDidFinish)];	
	
	currentImageView.frame = [currentPan frameAtEndOfDriftForImage:currentImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	
	[UIView commitAnimations];
}

- (void)driftAnimationDidFinish {
	if (state != DTSlideshowViewStateStopping && state != DTSlideshowViewStateRestarting) {
		if (nextImage && nextIndex != currentIndex) {
			self.nextPan = [DTSlideshowPan randomPanWithSecondsPerTransition:secondsPerTransition 
												   secondsBetweenTransitions:secondsBetweenTransitions];
			ifResponds(delegate, @selector(slideshowView:willDisplayImageAtIndex:),
					   [delegate slideshowView:self willDisplayImageAtIndex:nextIndex]);
			[self startImageTransition];
		}
		else { // Data source hasn't supplied the image yet, or it's the same image
			[self startDecelerateAnimation];
		}
	}
	else { // Stopping
		[self startFadeAnimation];
	}
}

- (void)startDecelerateAnimation {
	[UIView beginAnimations:@"Slideshow" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:secondsPerTransition];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(decelerateAnimationDidFinish)];	
	
	currentImageView.frame = [currentPan frameAtEndOfDecelerateForImage:currentImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	
	[UIView commitAnimations];	
}

- (void)decelerateAnimationDidFinish {
	self.nextPan = [DTSlideshowPan randomPanContinuingFromDeceleratedPan:currentPan 
													secondsPerTransition:self.secondsPerTransition 
											   secondsBetweenTransitions:self.secondsBetweenTransitions];
	[self startAccelerateAnimation];
}

- (void)startAccelerateAnimation {
	[UIView beginAnimations:@"Slideshow" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:secondsPerTransition];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(accelerateAnimationDidFinish)];	
	
	currentImageView.frame = [nextPan frameAtStartOfDriftForImage:currentImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	
	[UIView commitAnimations];		
}

- (void)accelerateAnimationDidFinish {
	self.currentPan = self.nextPan;
	self.nextPan = nil;
	[self startDriftAnimation];
}

- (void)startFadeAnimation {
	[UIView beginAnimations:@"Slideshow" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:secondsPerTransition];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidFinish)];	
	
	currentImageView.frame = [currentPan frameAtEndOfPanForImage:currentImage inFrame:self.frame withMaxZoomFactor:maxZoomFactor];
	currentImageView.alpha = 0.0;
	
	[UIView commitAnimations];
}

- (void)fadeAnimationDidFinish {
	NSAssert (state == DTSlideshowViewStateStopping  || state == DTSlideshowViewStateRestarting, @"Fade animation finished, but we're not in a stopping or restarting state."); 
	[currentImageView removeFromSuperview];
	[overlayButton removeFromSuperview];
	[disclosureImageView removeFromSuperview];
	self.currentImage = nil;
	self.nextImage = nil;
	self.currentImageView = nil;
	self.nextImageView = nil;
	self.currentPan = nil;
	self.nextPan = nil;
	self.overlayButton = nil;
	if (state == DTSlideshowViewStateRestarting) {
		[self start];
	}
	else {
		self.state = DTSlideshowViewStateStopped;
	}
}

- (NSInteger)nextIndexAfter:(NSInteger)index {
	index++;
	if (index == numberOfImages) index = 0;
	return index;
}

- (void)addOverlayButton {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = self.bounds;
	[self addSubview:button];
	if (disclosureImageView) {
		NSAssert (!disclosureImageView.superview, @"Didn't expect disclosureImageView to have a superview when we're adding the overlay button.");
		[self addSubview:disclosureImageView];
	}
	[button addTarget:self action:@selector(overlayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (CGRect)frameForDisclosureImageView {
	NSAssert (disclosureImageView, @"Asked for a frame for a nil disclosureImageview");
	CGRect frame;
	frame.size.width = disclosureImageView.bounds.size.width;
	frame.size.height = disclosureImageView.bounds.size.height;
	frame.origin.x = self.bounds.size.width - frame.size.width - 10.0;
	frame.origin.y = self.bounds.size.height / 2 - frame.size.height / 2;
	return frame;
}

@end
