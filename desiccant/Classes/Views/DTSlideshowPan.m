//
//  DTSlideshowPan.m
//
//  Created by Curtis Duhn on 12/24/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSlideshowPan.h"
#import "DTSlideshowPanPoint.h"


@interface DTSlideshowPan()
@property (nonatomic) BOOL easesIn;
@end

@implementation DTSlideshowPan
@synthesize startPoint, endPoint, secondsPerTransition, secondsBetweenTransitions, easesIn;

#pragma mark Memory management

- (void)dealloc {
	self.startPoint = nil;
	self.endPoint = nil;
	
    [super dealloc];
}

#pragma mark Constructors

- (id) initWithStartPoint:(DTSlideshowPanPoint *)theStartPoint 
				 endPoint:(DTSlideshowPanPoint *)theEndPoint 
	 secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions
{
	if ((self = [super init])) {
		self.startPoint = theStartPoint;
		self.endPoint = theEndPoint;
		self.secondsPerTransition = theSecondsPerTransition;
		self.secondsBetweenTransitions = theSecondsBetweenTransitions; 
	}
	return self;
}

- (id)initWithRandomStartAndEndPointsSecondsPerTransition:(NSTimeInterval)theSecondsPerTransition
								secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions
{
	if (self = [self initWithStartPoint:[DTSlideshowPanPoint randomPoint] 
							   endPoint:[DTSlideshowPanPoint randomPoint]
				   secondsPerTransition:theSecondsPerTransition
			  secondsBetweenTransitions:theSecondsBetweenTransitions]) 
	{}
	return self;
}

- (id)initWithRandomEndPointContinuingFromDeceleratedPan:(DTSlideshowPan *)thePreviousPan 
									secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
							   secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions 
{
	if (self = [self initWithStartPoint:[thePreviousPan decelerationEndPoint] 
							   endPoint:[DTSlideshowPanPoint randomPoint]
				   secondsPerTransition:theSecondsPerTransition
			  secondsBetweenTransitions:theSecondsBetweenTransitions]) 
	{
		self.easesIn = YES;
	}
	return self;
}

+ (id)randomPanWithSecondsPerTransition:(NSTimeInterval)theSecondsPerTransition
			  secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions 
{
	return [[[self alloc] initWithRandomStartAndEndPointsSecondsPerTransition:theSecondsPerTransition 
													secondsBetweenTransitions:theSecondsBetweenTransitions] autorelease];
}

+ (id)randomPanContinuingFromDeceleratedPan:(DTSlideshowPan *)thePreviousPan 
					   secondsPerTransition:(NSTimeInterval)theSecondsPerTransition
				  secondsBetweenTransitions:(NSTimeInterval)theSecondsBetweenTransitions 	
{
	return [[[self alloc] initWithRandomEndPointContinuingFromDeceleratedPan:thePreviousPan 
														secondsPerTransition:theSecondsPerTransition
												   secondsBetweenTransitions:theSecondsBetweenTransitions] autorelease];
}

#pragma mark Public methods

- (CGRect)frameAtStartOfPanForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self.startPoint frameForImage:image inFrame:containerFrame withMaxZoomFactor:maxZoomFactor];
}

- (CGRect)frameAtStartOfDriftForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self.driftStartPoint frameForImage:image inFrame:containerFrame withMaxZoomFactor:maxZoomFactor];
}

- (CGRect)frameAtEndOfDriftForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self.driftEndPoint frameForImage:image inFrame:containerFrame withMaxZoomFactor:maxZoomFactor];
}

- (CGRect)frameAtEndOfPanForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self.endPoint frameForImage:image inFrame:containerFrame withMaxZoomFactor:maxZoomFactor];
}

- (CGRect)frameAtEndOfDecelerateForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self.decelerationEndPoint frameForImage:image inFrame:containerFrame withMaxZoomFactor:maxZoomFactor];
}

#pragma mark Dynamic properties

- (DTSlideshowPanPoint *)decelerationEndPoint {
	return [self.driftEndPoint plus:self.decelerationDistance];
}

// If the normal distance traveled during a transition animation is endPoint - driftEndPoint, and we want our 
// decelaration animation to start at the same velocity and last for the same duration, then I believe the distance
// traveled during the deceleration animation will be 2/3 of the normal linear transition distance.  I base this on
// an educated guess that UIViewAnimationCurveEaseOut is a cubic Bezier curve with control points 
// (0, 0), (1/3, 1/2), (2/3, 1), and (1, 1).  I don't know if this is the actual curve, but it seems to be a reasonable 
// assumption.
- (DTSlideshowPanPoint *)decelerationDistance {
	return self.easedTransitionDistance;
}

- (DTSlideshowPanPoint *)easedTransitionDistance {
	return [self.transitionDistance times:2.0/3];
}

- (DTSlideshowPanPoint *)driftStartPoint {
	return [self.startPoint plus:self.startTransitionDistance];
}

- (DTSlideshowPanPoint *)driftEndPoint {
	return [self.driftStartPoint plus:self.driftDistance];
}

- (DTSlideshowPanPoint *)transitionDistance {
	return [self.totalDistance times:(self.secondsPerTransition / self.totalSeconds)];
}

- (DTSlideshowPanPoint *)startTransitionDistance {
	if (self.easesIn) {
		return self.easedTransitionDistance;
	}
	else {
		return self.transitionDistance;
	}
}

- (DTSlideshowPanPoint *)driftDistance {
	return [self.totalDistance minus:[self.transitionDistance plus:self.startTransitionDistance]];
}

- (NSTimeInterval)totalSeconds {
	return self.secondsPerTransition + self.secondsBetweenTransitions + self.secondsPerTransition;
}

- (DTSlideshowPanPoint *)totalDistance {
	return [self.endPoint minus:self.startPoint];
}

@end
