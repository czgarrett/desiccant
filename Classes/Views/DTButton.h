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

@property (assign) BOOL shiny;
@property (assign) BOOL shadow;
@property (assign) CGFloat cornerRadius;
@property (assign) CGFloat borderWidth;

- (void) highlight;


- (void) dependsOnReachability: (DTReachability *) reachability;
- (void) reachabilityChanged: (NSNotification *) notification;
- (NSArray *)gradientLocations;
- (NSArray *)normalGradientColors;
- (NSArray *)highlightedGradientColors;
- (NSArray *)selectedGradientColors;
- (void)configure;

@end
