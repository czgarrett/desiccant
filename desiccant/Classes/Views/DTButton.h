//  DTButton.h

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DTReachability.h"

@interface DTButton : UIButton {
	CAGradientLayer *normalGradient;
	CAGradientLayer *highlightedGradient;
	CAGradientLayer *disabledGradient;
	CAGradientLayer *selectedGradient;
   
   BOOL dependsOnReachability;
}

@property (nonatomic, assign) BOOL shiny;
@property (nonatomic, assign) BOOL shadow;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
// Value should be 0-1.0.
@property (nonatomic, assign) CGFloat disabledShadingLevel;

- (void) highlight;


- (void) dependsOnReachability: (DTReachability *) reachability;
- (void) reachabilityChanged: (NSNotification *) notification;
- (NSArray *)gradientLocations;
- (NSArray *)normalGradientColors;
- (NSArray *)highlightedGradientColors;
- (NSArray *)selectedGradientColors;
- (void)configure;
- (void)configureGradients;


@end
