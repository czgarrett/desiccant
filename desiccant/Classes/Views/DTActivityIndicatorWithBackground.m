//
//  DTActivityIndicatorWithBackground.m
//  medaxion
//
//  Created by Garrett Christopher on 11/17/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "DTActivityIndicatorWithBackground.h"

@interface DTActivityIndicatorWithBackground() {
@private
   CGFloat cornerRadius;
   UIActivityIndicatorView *_systemIndicator;
   UILabel *_textLabel;
   UIImageView *_iconImageView;
}

- (void) setup;

@end

@implementation DTActivityIndicatorWithBackground

@synthesize iconImage = _iconImage;

- (id)initWithFrame:(CGRect)frame {
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

   _systemIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
   _systemIndicator.frame = CGRectMake(
           self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
           self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height) / 2.0),
           _systemIndicator.frame.size.width,
           _systemIndicator.frame.size.height);
   [_systemIndicator startAnimating];
   _systemIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

   _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
   _textLabel.font = [UIFont boldSystemFontOfSize:17.0];
   _textLabel.textColor = [UIColor whiteColor];
   _textLabel.backgroundColor = [UIColor clearColor];
   _textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
   _textLabel.hidden = YES;

   _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
   _iconImageView.hidden = YES;

   [self addSubview: _systemIndicator];
   [self addSubview: _textLabel];
   [self addSubview: _iconImageView];

   self.backgroundColor = [UIColor clearColor];
}

- (void)setText:(NSString *)aText {
   _textLabel.hidden = ![aText length];
   _textLabel.text = aText;
   [_textLabel sizeToFit];
   [self setNeedsLayout];
}

- (NSString *)text {
    return _textLabel.text;
}

- (void)setIconImage:(UIImage *)aCompletedImage {
    [_iconImage autorelease];
    _iconImage = [aCompletedImage retain];

    [_iconImageView setImage:_iconImage];
    [_iconImageView sizeToFit];
    [self setNeedsLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   CGContextRef ctx = UIGraphicsGetCurrentContext();
   CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite: 0.0 alpha: 0.5].CGColor);
   UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: cornerRadius];
   [roundedRect fill];
}

- (void)layoutSubviews {
   if ([_textLabel.text length]) {
       _systemIndicator.frame = CGRectMake(
               self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
               self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height - _textLabel.frame.size.height) / 2.0),
               _systemIndicator.frame.size.width,
               _systemIndicator.frame.size.height);
       _textLabel.frame = CGRectMake(
               self.bounds.origin.x + floorf((self.bounds.size.width - _textLabel.frame.size.width) / 2.0),
               _systemIndicator.frame.origin.x + _systemIndicator.frame.size.height,
               _textLabel.frame.size.width,
               _textLabel.frame.size.height);
    } else {
       _systemIndicator.frame = CGRectMake(
               self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
               self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height) / 2.0),
               _systemIndicator.frame.size.width,
               _systemIndicator.frame.size.height);
    }

    if (_iconImageView.image) {
        _iconImageView.frame = CGRectMake(
                _systemIndicator.frame.origin.x + floorf((_systemIndicator.frame.size.width - _iconImageView.frame.size.width)/2.0),
                _systemIndicator.frame.origin.y + _systemIndicator.frame.size.height - _iconImageView.frame.size.height,
                _iconImageView.frame.size.width,
                _iconImageView.frame.size.height);
    }
}

- (void)showActivity {
    self.hidden = NO;
    _systemIndicator.hidden = NO;
    _iconImageView.hidden = YES;
}

- (void)showActivityWithText:(NSString *)text {
    [self setText:text];
    [self showActivity];
}

- (void)showIconImage {
    self.hidden = NO;
    _systemIndicator.hidden = YES;
    _iconImageView.hidden = NO;
}

- (void)showIconImageWithText:(NSString *)text {
    [self setText:text];
    [self showIconImage];
}

- (void)hide {
    self.hidden = YES;
}

- (void)dealloc {
   [_systemIndicator release];
   [_textLabel release];
   [_iconImage release];
   [_iconImageView release];
   [super dealloc];
}

@end
