//
//  DTSlideshowView.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSlideshowPan.h"

typedef enum {
	DTSlideshowViewStateStopped,
	DTSlideshowViewStateWaitingForFirstImage,
	DTSlideshowViewStateAnimating,
	DTSlideshowViewStateStopping,
	DTSlideshowViewStateRestarting
} DTSlideshowViewState;

@protocol DTSlideshowViewDelegate;
@protocol DTSlideshowViewDataSource;

@interface DTSlideshowView : UIView {
	id<DTSlideshowViewDataSource> dataSource;
	id<DTSlideshowViewDelegate> delegate;
	NSTimeInterval secondsBetweenTransitions;
	NSTimeInterval secondsPerTransition;
	NSInteger currentIndex;
	NSInteger nextIndex;
	NSInteger numberOfImages;
	DTSlideshowViewState state;
	UIImage *currentImage;
	UIImage *nextImage;
	UIImageView *currentImageView;
	UIImageView *nextImageView;
	DTSlideshowPan *currentPan;
	DTSlideshowPan *nextPan;
	CGFloat maxZoomFactor;
	UIButton *overlayButton;
	UIImage *dtDisclosureImage;
	UIImageView *disclosureImageView;
}

@property (nonatomic, assign) id<DTSlideshowViewDataSource> dataSource;
@property (nonatomic, assign) id<DTSlideshowViewDelegate> delegate;
@property (nonatomic) NSTimeInterval secondsBetweenTransitions;
@property (nonatomic) NSTimeInterval secondsPerTransition;
@property (nonatomic) CGFloat maxZoomFactor;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, readonly) NSInteger nextIndex;
@property (nonatomic, readonly) NSInteger numberOfImages;
@property (nonatomic, readonly) DTSlideshowViewState state;
@property (nonatomic, retain, readonly) UIImage *currentImage;
@property (nonatomic, retain, readonly) UIImage *nextImage;
@property (nonatomic, retain, readonly) UIImageView *currentImageView;
@property (nonatomic, retain, readonly) UIImageView *nextImageView;
@property (nonatomic, retain, readonly) DTSlideshowPan *currentPan;
@property (nonatomic, retain, readonly) DTSlideshowPan *nextPan;
@property (nonatomic, retain) UIImage *disclosureImage;
@property (nonatomic, retain, readonly) UIImageView *disclosureImageView;

- (void)start;
- (void)stop;
- (void)setImage:(UIImage *)image forIndex:(NSInteger)index;
- (void)skipImageWithIndex:(NSInteger)index;

@end

@protocol DTSlideshowViewDataSource <NSObject>
- (NSInteger)numberOfImagesInSlideshowView:(DTSlideshowView *)slideshowView;
- (void)slideshowView:(DTSlideshowView *)slideshowView requestsImageAtIndex:(NSInteger)index;
@end

@protocol DTSlideshowViewDelegate <NSObject>
@optional
- (void)slideshowViewWillStartAnimating:(DTSlideshowView *)slideshowView;
- (void)slideshowViewDidStartAnimating:(DTSlideshowView *)slideshowView;
- (void)slideshowView:(DTSlideshowView *)slideshowView willDisplayImageAtIndex:(NSInteger)index;
- (void)slideshowView:(DTSlideshowView *)slideshowView didDisplayImageAtIndex:(NSInteger)index;
- (void)slideshowView:(DTSlideshowView *)slideshowView willSelectImageAtIndex:(NSInteger)index;
- (void)slideshowView:(DTSlideshowView *)slideshowView didSelectImageAtIndex:(NSInteger)index;
- (void)slideshowViewWillStopAnimating:(DTSlideshowView *)slideshowView;
- (void)slideshowViewDidStopAnimating:(DTSlideshowView *)slideshowView;
@end



