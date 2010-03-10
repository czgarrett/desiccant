//
//  DTSlideshowPanPoint.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/24/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSlideshowPanPoint.h"
#import "Security/Security.h"

@interface DTSlideshowPanPoint()
- (CGRect)defaultFrameForImage:(UIImage *)image;
- (CGRect)scaleFrame:(CGRect)frame toFit:(CGRect)containerFrame;
- (CGRect)zoomFrame:(CGRect)frame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (CGRect)translateFrame:(CGRect)frame inFrame:(CGRect)containerFrame;
- (CGRect)frame:(CGRect)frame scaledToWidth:(CGFloat)newWidth;
- (CGRect)frame:(CGRect)frame scaledToHeight:(CGFloat)newHeight;
- (BOOL)frame:(CGRect)frame isTallerThan:(CGRect)otherFrame;
// Returns 1.0 if z == 0.0, up to maxZoomFactor if z == 1.0
- (CGFloat)zoomFactorWithMaxZoomFactor:(CGFloat)maxZoomFactor;
@end

@implementation DTSlideshowPanPoint
@synthesize x, y, z;

//- (void)dealloc {
//    [super dealloc];
//}

- (id)initWithX:(CGFloat)xParam Y:(CGFloat)yParam Z:(CGFloat)zParam {
	if (self = [super init]) {
		self.x = xParam;
		self.y = yParam;
		self.z = zParam;
	}
	return self;
}

- (id)initWithRandomCoordinates {
	if (self = [self initWithX:(CGFloat)arc4random() / 0x100000000
							 Y:(CGFloat)arc4random() / 0x100000000
							 Z:(CGFloat)arc4random() / 0x100000000]) {
	}
	return self;
}

+ (id)pointWithX:(CGFloat)xParam Y:(CGFloat)yParam Z:(CGFloat)zParam {
	return [[[self alloc] initWithX:xParam Y:yParam Z:zParam] autorelease];
}

+ (id)randomPoint {
	return [[[self alloc] initWithRandomCoordinates] autorelease];
}

- (CGRect)frameForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	return [self translateFrame:[self zoomFrame:[self scaleFrame:[self defaultFrameForImage:image] 
														   toFit:containerFrame] 
							  withMaxZoomFactor:maxZoomFactor] 
				 inFrame:containerFrame];
}

- (DTSlideshowPanPoint *)plus:(DTSlideshowPanPoint *)point {
	return [DTSlideshowPanPoint pointWithX:self.x + point.x 
										 Y:self.y + point.y
										 Z:self.z + point.z];
}

- (DTSlideshowPanPoint *)minus:(DTSlideshowPanPoint *)point {
	return [DTSlideshowPanPoint pointWithX:self.x - point.x 
										 Y:self.y - point.y
										 Z:self.z - point.z];
}

- (DTSlideshowPanPoint *)dividedBy:(CGFloat)divisor {
	return [DTSlideshowPanPoint pointWithX:self.x / divisor 
										 Y:self.y / divisor
										 Z:self.z / divisor];
}

- (DTSlideshowPanPoint *)times:(CGFloat)factor {
	return [DTSlideshowPanPoint pointWithX:self.x * factor 
										 Y:self.y * factor
										 Z:self.z * factor];
}

#pragma mark Private methods

- (CGRect)defaultFrameForImage:(UIImage *)image {
	return CGRectMake(0, 0, image.size.width, image.size.height);
}

- (CGRect)scaleFrame:(CGRect)frame toFit:(CGRect)containerFrame {
	if ([self frame:[self frame:frame 
				  scaledToWidth:containerFrame.size.width] 
	   isTallerThan:containerFrame]) 
	{
		return [self frame:frame
			 scaledToWidth:containerFrame.size.width];
	}
	else {
		return [self frame:frame
			scaledToHeight:containerFrame.size.height];
	}
}

- (CGRect)zoomFrame:(CGRect)frame withMaxZoomFactor:(CGFloat)maxZoomFactor {
	CGFloat newWidth = frame.size.width * [self zoomFactorWithMaxZoomFactor:maxZoomFactor];
	CGFloat newHeight = frame.size.height * [self zoomFactorWithMaxZoomFactor:maxZoomFactor];
//	CGFloat newX = frame.origin.x - self.x * (newWidth - frame.size.width);
//	CGFloat newY = frame.origin.y - self.y * (newHeight - frame.size.height);
	return CGRectMake(frame.origin.x, frame.origin.y, newWidth, newHeight);
}

- (CGRect)translateFrame:(CGRect)frame inFrame:(CGRect)containerFrame {
	CGFloat deltaX = frame.size.width - containerFrame.size.width;
	CGFloat deltaY = frame.size.height - containerFrame.size.height;
	CGFloat newX = frame.origin.x - (self.x * deltaX);
	CGFloat newY = frame.origin.y - (self.y * deltaY);
	return CGRectMake(newX, newY, frame.size.width, frame.size.height);
}

- (CGRect)frame:(CGRect)frame scaledToWidth:(CGFloat)newWidth {
	CGFloat newHeight = frame.size.height * (newWidth / frame.size.width);
	return CGRectMake(frame.origin.x, frame.origin.y, newWidth, newHeight);
}

- (CGRect)frame:(CGRect)frame scaledToHeight:(CGFloat)newHeight {
	CGFloat newWidth = frame.size.width * (newHeight / frame.size.height);
	return CGRectMake(frame.origin.x, frame.origin.y, newWidth, newHeight);
}

- (BOOL)frame:(CGRect)frame isTallerThan:(CGRect)otherFrame {
	return frame.size.height > otherFrame.size.height;
}

// Returns 1.0 if z == 0.0, up to maxZoomFactor if z == 1.0
- (CGFloat)zoomFactorWithMaxZoomFactor:(CGFloat)maxZoomFactor {
	return 1.0 + self.z * (maxZoomFactor - 1.0);
}

@end
