//
//  DTActivityIndicatorWithBackground.m
//  medaxion
//
//  Created by Garrett Christopher on 11/17/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTActivityIndicatorWithBackground.h"

@interface DTActivityIndicatorWithBackground () {
@private
    UIActivityIndicatorView *_systemIndicator;
    UIImageView *_iconImageView;
}
- (void)setup;
@end

@implementation DTActivityIndicatorWithBackground

@synthesize titleLabel = _titleLabel;
@synthesize iconImage = _iconImage;
@synthesize cornerRadius = _cornerRadius;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    _cornerRadius = 10.0;

    _systemIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _systemIndicator.frame = CGRectMake(
            self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
            self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height) / 2.0),
            _systemIndicator.frame.size.width,
            _systemIndicator.frame.size.height);
    [_systemIndicator startAnimating];
    _systemIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.hidden = YES;

    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.hidden = YES;

    [self addSubview:_systemIndicator];
    [self addSubview:_titleLabel];
    [self addSubview:_iconImageView];

    self.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)aTitle {
    _titleLabel.hidden = ![aTitle length];
    _titleLabel.text = aTitle;
    [_titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)title {
    return _titleLabel.text;
}

- (void)setFont:(UIFont *)font {
    if (font) {
        _titleLabel.font = font;
        [self sizeToFit];
        [self setNeedsLayout];
    }
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
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.0 alpha:0.5].CGColor);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [roundedRect fill];
}

- (void)layoutSubviews {
    if ([_titleLabel.text length]) {
        _systemIndicator.frame = CGRectMake(
                self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
                self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height - _titleLabel.frame.size.height) / 2.0),
                _systemIndicator.frame.size.width,
                _systemIndicator.frame.size.height);
        _titleLabel.frame = CGRectMake(
                self.bounds.origin.x + floorf((self.bounds.size.width - _titleLabel.frame.size.width) / 2.0),
                _systemIndicator.frame.origin.x + _systemIndicator.frame.size.height,
                _titleLabel.frame.size.width,
                _titleLabel.frame.size.height);
    } else {
        _systemIndicator.frame = CGRectMake(
                self.bounds.origin.x + floorf((self.bounds.size.width - _systemIndicator.frame.size.width) / 2.0),
                self.bounds.origin.y + floorf((self.bounds.size.height - _systemIndicator.frame.size.height) / 2.0),
                _systemIndicator.frame.size.width,
                _systemIndicator.frame.size.height);
    }

    if (_iconImageView.image) {
        _iconImageView.frame = CGRectMake(
                _systemIndicator.frame.origin.x + floorf((_systemIndicator.frame.size.width - _iconImageView.frame.size.width) / 2.0),
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

- (void)showActivityWithTitle:(NSString *)text {
    [self setTitle:text];
    [self showActivity];
}

- (void)showIconImage {
    self.hidden = NO;
    _systemIndicator.hidden = YES;
    _iconImageView.hidden = NO;
}

- (void)showIconImageWithTitle:(NSString *)text {
    [self setTitle:text];
    [self showIconImage];
}

- (void)hide {
    self.hidden = YES;
}

- (void)dealloc {
    [_systemIndicator release];
    [_titleLabel release];
    [_iconImage release];
    [_iconImageView release];
    [super dealloc];
}

@end
