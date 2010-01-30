//
//  DTSlideshowPan.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/24/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSlideshowPanPoint.h"

@interface DTSlideshowPan : NSObject {
	DTSlideshowPanPoint *startPoint;
	DTSlideshowPanPoint *endPoint;
	NSTimeInterval secondsPerTransition;
	NSTimeInterval secondsBetweenTransitions;
	BOOL easesIn;
}

@property (nonatomic, retain) DTSlideshowPanPoint *startPoint;
@property (nonatomic, retain) DTSlideshowPanPoint *endPoint;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *decelerationEndPoint;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *driftStartPoint;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *driftEndPoint;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *totalDistance;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *transitionDistance;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *startTransitionDistance;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *easedTransitionDistance;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *driftDistance;
@property (nonatomic, retain, readonly) DTSlideshowPanPoint *decelerationDistance;
@property (nonatomic) NSTimeInterval secondsPerTransition;
@property (nonatomic) NSTimeInterval secondsBetweenTransitions;
@property (nonatomic, readonly) NSTimeInterval totalSeconds;
@property (nonatomic, readonly) BOOL easesIn;

- (id) initWithStartPoint:(DTSlideshowPanPoint *)theStartPoint 
				 endPoint:(DTSlideshowPanPoint *)theEndPoint 
	 secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions;

- (id)initWithRandomStartAndEndPointsSecondsPerTransition:(NSTimeInterval)theSecondsPerTransition
								secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions;

- (id)initWithRandomEndPointContinuingFromDeceleratedPan:(DTSlideshowPan *)thePreviousPan 
									secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
							   secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions;

+ (id)randomPanWithSecondsPerTransition:(NSTimeInterval)theSecondsPerTransition
			  secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions;

+ (id)randomPanContinuingFromDeceleratedPan:(DTSlideshowPan *)thePreviousPan 
					   secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
				  secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions;

- (CGRect)frameAtStartOfPanForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (CGRect)frameAtStartOfDriftForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (CGRect)frameAtEndOfDriftForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (CGRect)frameAtEndOfPanForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (CGRect)frameAtEndOfDecelerateForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;

@end
