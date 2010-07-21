//  DTButton.m

#import "DTButton.h"
#import "Zest.h"
#import "DTReachability.h"

@interface DTButton()
- (void)configureGradients;
- (CGFloat)luminance;
@property (nonatomic, retain) CAGradientLayer *normalGradient;
@property (nonatomic, retain) CAGradientLayer *highlightedGradient;
@end

@implementation DTButton
@synthesize normalGradient, highlightedGradient;

- (void)dealloc {
   if (dependsOnReachability) {
      [[NSNotificationCenter defaultCenter] removeObserver: self];
   }
	self.normalGradient = nil;
	self.highlightedGradient = nil;
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
   NSLog(@"DTButton awakeFromNib");
    [self configure];
}

- (id)initWithFrame:(CGRect)frame {
   NSLog(@"DTButton initWithFrame:");
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

#pragma mark Public

- (NSArray *)normalGradientColors {
	CGFloat luminance = [self luminance];
	return [NSArray arrayWithObjects:
			(id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
			(id)[UIColor colorWithWhite:1.0f alpha:0.5f + 0.15 * luminance].CGColor,
			(id)[UIColor colorWithWhite:1.0f alpha:0.15f + 0.15 * luminance].CGColor,
			(id)[UIColor colorWithWhite:1.0f alpha:0.0f + 0.02 * luminance].CGColor,
			(id)[UIColor colorWithWhite:1.0f alpha:0.0f + 0.01 * luminance].CGColor,
			(id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
			nil];
}

- (NSArray *)highlightedGradientColors {
	CGFloat luminance = [self luminance];
	return [NSArray arrayWithObjects:
			(id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
			(id)[UIColor colorWithWhite:0.5f + 0.5f * luminance alpha:0.8f].CGColor,
			(id)[UIColor colorWithWhite:0.2f + 0.4f * luminance alpha:0.6f].CGColor,
			(id)[UIColor colorWithWhite:0.1f + 0.1f * luminance alpha:0.5f].CGColor,
			(id)[UIColor colorWithWhite:0.1f + 0.1f * luminance alpha:0.3f].CGColor,
			(id)[UIColor colorWithWhite:0.0f alpha:0.2f].CGColor,
			nil];
}

- (NSArray *)gradientLocations {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:0.0f],
			[NSNumber numberWithFloat:0.1f],
			[NSNumber numberWithFloat:0.5f],
			[NSNumber numberWithFloat:0.5f],
			[NSNumber numberWithFloat:0.8f],
			[NSNumber numberWithFloat:1.0f],
			nil];
}

#pragma mark Reachability

- (void) dependsOnReachability: (DTReachability *) reachability {
   dependsOnReachability = YES;
   [[NSNotificationCenter defaultCenter] addObserver: self 
                                            selector: @selector(reachabilityChanged:) 
                                                name: kReachabilityChangedNotification 
                                              object: reachability];
   self.enabled = [reachability isReachable];
}

- (void) reachabilityChanged: (NSNotification *) notification {
   DTReachability *reachability = [notification object];
   self.enabled = [reachability isReachable];
}

#pragma mark UIView

- (void)setBackgroundColor:(UIColor *)theColor {
	super.backgroundColor = theColor;
	
	if (normalGradient.superlayer) {	
		[normalGradient removeFromSuperlayer];
		[self configureGradients];
		[self.layer addSublayer:normalGradient];
	}
	else if (highlightedGradient.superlayer) {
		[highlightedGradient removeFromSuperlayer];
		[self configureGradients];
		[self.layer addSublayer:highlightedGradient];
	}
	else {
		[self configureGradients];
	}
}

- (void)setFrame:(CGRect)theFrame {
	super.frame = theFrame;
    normalGradient.frame = self.layer.bounds;
    highlightedGradient.frame = self.layer.bounds;
}

#pragma mark UIControl

- (void)setHighlighted:(BOOL)shouldHighlight {
	if (shouldHighlight && normalGradient.superlayer) {
		[self.layer replaceSublayer:normalGradient with:highlightedGradient];
	}
	else if (!shouldHighlight && highlightedGradient.superlayer) {
		[self.layer replaceSublayer:highlightedGradient with:normalGradient];
	}
	super.highlighted = shouldHighlight;
}

- (void)configure {
	self.layer.borderWidth = 1.0f;
   self.layer.borderColor = [UIColor colorWithRed:168.0f/255.0f green:171.0f/255.0f blue:173.0f/255.0f alpha:1.0f].CGColor;
   self.layer.cornerRadius = 8.0f;
   self.layer.masksToBounds = YES;
	
	[self configureGradients];
	
   //[self.layer insertSublayer:normalGradient atIndex: 0];	
   [self.layer addSublayer: normalGradient];	
}

#pragma mark Private

- (CGFloat) cornerRadius {
   return self.layer.cornerRadius;
}

- (void) setCornerRadius:(CGFloat) radius {
   self.layer.cornerRadius = radius;
}

- (void)configureGradients {
	self.normalGradient = [CAGradientLayer layer];
    normalGradient.frame = self.layer.bounds;
    normalGradient.locations = [self gradientLocations];
    normalGradient.colors = [self normalGradientColors];
	
	self.highlightedGradient = [CAGradientLayer layer];
	highlightedGradient.frame = self.layer.bounds;
	highlightedGradient.locations = [self gradientLocations];
	highlightedGradient.colors = [self highlightedGradientColors];
   
   
}

- (CGFloat)luminance {
	unless (self.backgroundColor) return 0.5;
	
	const CGFloat *c = CGColorGetComponents(self.backgroundColor.CGColor);
	CGFloat r = c[0];
	CGFloat g = c[1];
	CGFloat b = c[2];
	
	// http://en.wikipedia.org/wiki/Luma_(video)
	// Y = 0.2126 R + 0.7152 G + 0.0722 B
	// Thanks Erica Sadun.
	return r*0.2126f + g*0.7152f + b*0.0722f;
}

@end
