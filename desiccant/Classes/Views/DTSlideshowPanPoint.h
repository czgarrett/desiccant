//
//  DTSlideshowPanPoint.h
//
//  Created by Curtis Duhn on 12/24/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSlideshowPanPoint : NSObject {
	CGFloat x; // 0.0 is left-justified.  1.0 is right-justified
	CGFloat y; // 0.0 is top-justified.  1.0 is bottom-justified
	CGFloat z; // 0.0 is sized to fit the container with no margins, 1.0 is zoomed to the max zoom factor
}

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat z;

- (id)initWithX:(CGFloat)xParam Y:(CGFloat)yParam Z:(CGFloat)zParam;
- (id)initWithRandomCoordinates;
+ (id)pointWithX:(CGFloat)xParam Y:(CGFloat)yParam Z:(CGFloat)zParam;
+ (id)randomPoint;
- (CGRect)frameForImage:(UIImage *)image inFrame:(CGRect)containerFrame withMaxZoomFactor:(CGFloat)maxZoomFactor;
- (DTSlideshowPanPoint *)plus:(DTSlideshowPanPoint *)point;
- (DTSlideshowPanPoint *)minus:(DTSlideshowPanPoint *)point;
- (DTSlideshowPanPoint *)dividedBy:(CGFloat)divisor;
- (DTSlideshowPanPoint *)times:(CGFloat)factor;

@end
