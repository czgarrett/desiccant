//  DTButton.m

#import "DTButton.h"
#import "Zest.h"
#import "DTReachability.h"

@interface DTButton()
- (void)configureGradients;
- (CGFloat)luminance;
@property (nonatomic, retain) CAGradientLayer *normalGradient;
@property (nonatomic, retain) CAGradientLayer *highlightedGradient;
@property (nonatomic, retain) CAGradientLayer *disabledGradient;
@property (nonatomic, retain) CAGradientLayer *selectedGradient;
@end

@implementation DTButton
@synthesize normalGradient, highlightedGradient, disabledGradient, selectedGradient, disabledShadingLevel;

- (void)dealloc {
   if (dependsOnReachability) {
      [[NSNotificationCenter defaultCenter] removeObserver: self];
   }
	self.normalGradient = nil;
	self.highlightedGradient = nil;
   self.disabledGradient = nil;
   self.selectedGradient = nil;
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
   shiny = YES;
   self.disabledShadingLevel = 0.5;
    [self configure];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
       shiny = YES;
       self.disabledShadingLevel = 0.5;
       [self configure];
    }
    return self;
}

#pragma mark Public

- (NSArray *)normalGradientColors {
	CGFloat luminance = [self luminance];
   if (self.shiny) {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
              (id)[UIColor colorWithWhite:1.0f alpha:0.5f + 0.15 * luminance].CGColor,
              (id)[UIColor colorWithWhite:1.0f alpha:0.15f + 0.15 * luminance].CGColor,
              (id)[UIColor colorWithWhite:1.0f alpha:0.0f + 0.02 * luminance].CGColor,
              (id)[UIColor colorWithWhite:1.0f alpha:0.0f + 0.01 * luminance].CGColor,
              (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
              nil];      
   } else {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
              nil];
   }
}

- (NSArray *)selectedGradientColors {
   return [self highlightedGradientColors];
}

- (NSArray *)highlightedGradientColors {
	CGFloat luminance = [self luminance];
   if (self.shiny) {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
              (id)[UIColor colorWithWhite:0.5f + 0.5f * luminance alpha:0.8f].CGColor,
              (id)[UIColor colorWithWhite:0.2f + 0.4f * luminance alpha:0.6f].CGColor,
              (id)[UIColor colorWithWhite:0.1f + 0.1f * luminance alpha:0.5f].CGColor,
              (id)[UIColor colorWithWhite:0.1f + 0.1f * luminance alpha:0.3f].CGColor,
              (id)[UIColor colorWithWhite:0.0f alpha:0.2f].CGColor,
              nil];      
   } else {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite:0.0f alpha:0.2f].CGColor,
              nil];      
   }
}

- (NSArray *)disabledGradientColors {
	CGFloat luminance = [self luminance];
   CGFloat disabledShading = 0.5;
   if (self.shiny) {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite: disabledShading * 1.0f alpha:1.0f].CGColor,
              (id)[UIColor colorWithWhite: disabledShading * 0.5f + 0.5f * luminance alpha:0.8f].CGColor,
              (id)[UIColor colorWithWhite: disabledShading * 0.2f + 0.4f * luminance alpha:0.6f].CGColor,
              (id)[UIColor colorWithWhite: disabledShading * 0.1f + 0.1f * luminance alpha:0.5f].CGColor,
              (id)[UIColor colorWithWhite: disabledShading * 0.1f + 0.1f * luminance alpha:0.3f].CGColor,
              (id)[UIColor colorWithWhite: disabledShading * 0.0f alpha:0.2f].CGColor,
              nil];      
   } else {
      return [NSArray arrayWithObjects:
              (id)[UIColor colorWithWhite:0.0f alpha: disabledShading].CGColor,
              nil];      
   }
}


- (NSArray *)gradientLocations {
   if (self.shiny) {
      return [NSArray arrayWithObjects:
              [NSNumber numberWithFloat:0.0f],
              [NSNumber numberWithFloat:0.1f],
              [NSNumber numberWithFloat:0.5f],
              [NSNumber numberWithFloat:0.5f],
              [NSNumber numberWithFloat:0.8f],
              [NSNumber numberWithFloat:1.0f],
              nil];      
   } else {
      return nil;
   }
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

- (void) highlight {
   [self setHighlighted: YES];
}

- (void)setHighlighted:(BOOL)shouldHighlight {
   if (!self.selected) { // Selection trumps highlight
      super.highlighted = shouldHighlight;
      if (shouldHighlight && normalGradient.superlayer) {
         [self.layer replaceSublayer:normalGradient with:highlightedGradient];
      }
      else if (!shouldHighlight && highlightedGradient.superlayer) {
         [self.layer replaceSublayer:highlightedGradient with:normalGradient];
      }
   }
}

- (void) setSelected:(BOOL) shouldSelect {
   super.selected = shouldSelect;
	if (shouldSelect && normalGradient.superlayer) {
		[self.layer replaceSublayer:normalGradient with:selectedGradient];
	}
	else if (!shouldSelect && selectedGradient.superlayer) {
		[self.layer replaceSublayer: selectedGradient with:normalGradient];
	}
}

- (void)setEnabled:(BOOL)shouldEnable {
   if (shouldEnable && self.selected) {
      self.selected = YES;
   } else { // Only set the enabled gradient if not selected
      BOOL shouldDisable = !shouldEnable;
      if (shouldDisable && normalGradient.superlayer) {
         [self.layer replaceSublayer:normalGradient with:disabledGradient];
      }
      else if (!shouldDisable && disabledGradient.superlayer) {
         [self.layer replaceSublayer:disabledGradient with:normalGradient];
      }
   }
	super.enabled = shouldEnable;
}

- (void) setShadow: (BOOL) shouldShadow {
   if (shouldShadow) {
      self.layer.shadowColor = [[UIColor blackColor] CGColor];
      self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
      self.layer.shadowOpacity = 0.5f;
      self.layer.shadowRadius = 2.0f;         
   } else {
      self.layer.shadowOpacity = 0.0f;
   }
}

- (BOOL) shadow {
   return self.layer.shadowOpacity > 0.01;
}


- (void)configure {
   if (normalGradient) [normalGradient removeFromSuperlayer];
   if (highlightedGradient) [highlightedGradient removeFromSuperlayer];
   if (disabledGradient) [disabledGradient removeFromSuperlayer];
   if (selectedGradient) [selectedGradient removeFromSuperlayer];
	self.layer.borderWidth = 1.0f;
   self.layer.borderColor = [UIColor colorWithRed:168.0f/255.0f green:171.0f/255.0f blue:173.0f/255.0f alpha:1.0f].CGColor;
   self.layer.cornerRadius = 8.0f;
   self.layer.masksToBounds = NO;
   	
	[self configureGradients];
	if (!self.enabled) {
      [self.layer addSublayer: disabledGradient];
   } else if (self.selected) {
      [self.layer addSublayer: selectedGradient];	      
   } else {
      [self.layer addSublayer: normalGradient];	      
   }
}

- (void) setCornerRadius:(CGFloat) radius {
   self.layer.cornerRadius = radius;
   if(normalGradient) normalGradient.cornerRadius = radius;
   if(highlightedGradient) highlightedGradient.cornerRadius = radius;
   if(disabledGradient) disabledGradient.cornerRadius = radius;
   if(selectedGradient) selectedGradient.cornerRadius = radius;
}

- (CGFloat) cornerRadius {
   return self.layer.cornerRadius;
}

- (void) setBorderWidth: (CGFloat) width {
   self.layer.borderWidth = width;
}

- (CGFloat) borderWidth {
   return self.layer.borderWidth;
}

- (void) setShiny: (BOOL) newShiny {
   shiny = newShiny;
   [self configure];
}

- (BOOL)shiny {
    return shiny;
}

#pragma mark Private

- (void)configureGradients {
	self.normalGradient = [CAGradientLayer layer];
    normalGradient.frame = self.layer.bounds;
    normalGradient.locations = [self gradientLocations];
    normalGradient.colors = [self normalGradientColors];
   normalGradient.cornerRadius = self.layer.cornerRadius;
	
	self.highlightedGradient = [CAGradientLayer layer];
	highlightedGradient.frame = self.layer.bounds;
	highlightedGradient.locations = [self gradientLocations];
	highlightedGradient.colors = [self highlightedGradientColors];
   highlightedGradient.cornerRadius = self.layer.cornerRadius;

	self.selectedGradient = [CAGradientLayer layer];
	selectedGradient.frame = self.layer.bounds;
	selectedGradient.locations = [self gradientLocations];
	selectedGradient.colors = [self selectedGradientColors];
   selectedGradient.cornerRadius = self.layer.cornerRadius;
   
	self.disabledGradient = [CAGradientLayer layer];
	disabledGradient.frame = self.layer.bounds;
	disabledGradient.locations = [self gradientLocations];
	disabledGradient.colors = [self disabledGradientColors];   
   disabledGradient.cornerRadius = self.layer.cornerRadius;
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
