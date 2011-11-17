//
//  DTActivityIndicatorWithBackground.m
//  medaxion
//
//  Created by Garrett Christopher on 11/17/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTActivityIndicatorWithBackground.h"

@interface DTActivityIndicatorWithBackground() {
@private
   CGFloat cornerRadius;
}

- (void) setup;

@end

@implementation DTActivityIndicatorWithBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setup];
    }
    return self;
}

- (void) awakeFromNib {
   [self setup];
}

- (void) setup {
   cornerRadius = 10.0;
   UIActivityIndicatorView *systemIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] autorelease];
   systemIndicator.frame = self.bounds;
   [systemIndicator startAnimating];
   systemIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
                                      UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
   [self addSubview: systemIndicator];
   self.backgroundColor = [UIColor clearColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   CGContextRef ctx = UIGraphicsGetCurrentContext();
   CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite: 0.0 alpha: 0.5].CGColor);
   UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: cornerRadius];
   [roundedRect fill];
}

@end
