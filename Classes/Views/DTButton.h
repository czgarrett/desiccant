//  DTButton.h

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DTReachability.h"

@interface DTButton : UIButton {
	CAGradientLayer *normalGradient;
	CAGradientLayer *highlightedGradient;
   
   BOOL dependsOnReachability;
}

@property (assign) CGFloat cornerRadius;

- (void) dependsOnReachability: (DTReachability *) reachability;
- (void) reachabilityChanged: (NSNotification *) notification;
- (NSArray *)gradientLocations;
- (NSArray *)normalGradientColors;
- (NSArray *)highlightedGradientColors;
- (void)configure;

@end
