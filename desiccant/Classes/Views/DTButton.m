//  DTButton.m

#import "DTButton.h"
#import "Zest.h"
#import "DTReachability.h"

@import QuartzCore;

@interface DTButton() {
    BOOL _dependsOnReachability;
}
- (void)configureGradients;
- (CGFloat)luminance;

@property (nonatomic, strong) CAGradientLayer *normalGradient;
@property (nonatomic, strong) CAGradientLayer *highlightedGradient;
@property (nonatomic, strong) CAGradientLayer *disabledGradient;
@property (nonatomic, strong) CAGradientLayer *selectedGradient;


@end

@implementation DTButton

- (void)dealloc {
    if (_dependsOnReachability) {
        [[NSNotificationCenter defaultCenter] removeObserver: self];
    }
}

- (void)awakeFromNib {
	[super awakeFromNib];
    _shiny = YES;
    self.disabledShadingLevel = 0.5;
    [self configure];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _shiny = YES;
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
    _dependsOnReachability = YES;
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
	
	if (_normalGradient.superlayer) {
		[_normalGradient removeFromSuperlayer];
		[self configureGradients];
		[self.layer addSublayer:_normalGradient];
	}
	else if (_highlightedGradient.superlayer) {
		[_highlightedGradient removeFromSuperlayer];
		[self configureGradients];
		[self.layer addSublayer:_highlightedGradient];
	}
	else {
		[self configureGradients];
	}
}

- (void)setFrame:(CGRect)theFrame {
	super.frame = theFrame;
    _normalGradient.frame = self.layer.bounds;
    _highlightedGradient.frame = self.layer.bounds;
}

#pragma mark UIControl

- (void) highlight {
    [self setHighlighted: YES];
}

- (void)setHighlighted:(BOOL)shouldHighlight {
    if (!self.selected) { // Selection trumps highlight
        super.highlighted = shouldHighlight;
        if (shouldHighlight && _normalGradient.superlayer) {
            [self.layer replaceSublayer:_normalGradient with:_highlightedGradient];
        }
        else if (!shouldHighlight && _highlightedGradient.superlayer) {
            [self.layer replaceSublayer:_highlightedGradient with:_normalGradient];
        }
    }
}

- (void) setSelected:(BOOL) shouldSelect {
    super.selected = shouldSelect;
	if (shouldSelect && _normalGradient.superlayer) {
		[self.layer replaceSublayer:_normalGradient with:_selectedGradient];
	}
	else if (!shouldSelect && _selectedGradient.superlayer) {
		[self.layer replaceSublayer: _selectedGradient with:_normalGradient];
	}
}

- (void)setEnabled:(BOOL)shouldEnable {
    if (shouldEnable && self.selected) {
        self.selected = YES;
    } else { // Only set the enabled gradient if not selected
        BOOL shouldDisable = !shouldEnable;
        if (shouldDisable && _normalGradient.superlayer) {
            [self.layer replaceSublayer:_normalGradient with:_disabledGradient];
        }
        else if (!shouldDisable && _disabledGradient.superlayer) {
            [self.layer replaceSublayer:_disabledGradient with:_normalGradient];
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
    if (_normalGradient) [_normalGradient removeFromSuperlayer];
    if (_highlightedGradient) [_highlightedGradient removeFromSuperlayer];
    if (_disabledGradient) [_disabledGradient removeFromSuperlayer];
    if (_selectedGradient) [_selectedGradient removeFromSuperlayer];
	self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithRed:168.0f/255.0f green:171.0f/255.0f blue:173.0f/255.0f alpha:1.0f].CGColor;
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
   	
	[self configureGradients];
	if (!self.enabled) {
        [self.layer addSublayer: _disabledGradient];
    } else if (self.selected) {
        [self.layer addSublayer: _selectedGradient];
    } else {
        [self.layer addSublayer: _normalGradient];
    }
}

- (void) setCornerRadius:(CGFloat) radius {
    self.layer.cornerRadius = radius;
    if(_normalGradient) _normalGradient.cornerRadius = radius;
    if(_highlightedGradient) _highlightedGradient.cornerRadius = radius;
    if(_disabledGradient) _disabledGradient.cornerRadius = radius;
    if(_selectedGradient) _selectedGradient.cornerRadius = radius;
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
    _shiny = newShiny;
    [self configure];
}

#pragma mark Private

- (void)configureGradients {
	self.normalGradient = [CAGradientLayer layer];
    _normalGradient.frame = self.layer.bounds;
    _normalGradient.locations = [self gradientLocations];
    _normalGradient.colors = [self normalGradientColors];
    _normalGradient.cornerRadius = self.layer.cornerRadius;
	
	self.highlightedGradient = [CAGradientLayer layer];
	_highlightedGradient.frame = self.layer.bounds;
	_highlightedGradient.locations = [self gradientLocations];
	_highlightedGradient.colors = [self highlightedGradientColors];
    _highlightedGradient.cornerRadius = self.layer.cornerRadius;
    
	self.selectedGradient = [CAGradientLayer layer];
	_selectedGradient.frame = self.layer.bounds;
	_selectedGradient.locations = [self gradientLocations];
	_selectedGradient.colors = [self selectedGradientColors];
    _selectedGradient.cornerRadius = self.layer.cornerRadius;
    
	self.disabledGradient = [CAGradientLayer layer];
	_disabledGradient.frame = self.layer.bounds;
	_disabledGradient.locations = [self gradientLocations];
	_disabledGradient.colors = [self disabledGradientColors];
    _disabledGradient.cornerRadius = self.layer.cornerRadius;
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
