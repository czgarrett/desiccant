//
//  DTActivityIndicatorView.m
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>


@interface DTActivityIndicatorView() {
	NSInteger _activityCount;

}

@property (nonatomic, weak) UIActivityIndicatorView *childIndicator;
@property (nonatomic, weak) UIView *childIndicatorBackground;

@end

static DTActivityIndicatorStyle defaultStyle;

@implementation DTActivityIndicatorView

+ (void) setDefaultStyle: (DTActivityIndicatorStyle) style {
   defaultStyle = style;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
	UIActivityIndicatorView *newIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	if ((self = [super initWithFrame: CGRectMake(0.0, 0.0, 300.0, 300.0)])) {
		newIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		newIndicator.hidesWhenStopped = NO;
		self.childIndicator = newIndicator;
        
        UIView *childIndicatorBackground = [[UIView alloc] initWithFrame: CGRectMake(100.0, 100.0, 100.0, 100.0)];
        self.childIndicatorBackground = childIndicatorBackground;
        self.childIndicatorBackground.layer.cornerRadius = 10.0;
		self.childIndicatorBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
		[self.childIndicatorBackground addSubview: newIndicator];
        [self addSubview: childIndicatorBackground];
        _childIndicator.center = CGPointMake(50.0, 50.0);
        self.dtActivityIndicatorStyle = defaultStyle;
		_hidesWhenStopped = YES;
		_activityCount = 0;
	}
	return self;
}

- (void) setDtActivityIndicatorStyle: (DTActivityIndicatorStyle) style {
   _dtActivityIndicatorStyle = style;
   switch (_dtActivityIndicatorStyle) {
      case DTActivityIndicatorStyleNormal:
         break;
      case DTActivityIndicatorStyleDarkGrayBackground:
         self.childIndicatorBackground.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.5];
         break;
      default:
         break;
   }
}

- (void)startAnimating {
	if (_activityCount == 0) {
		[_childIndicator startAnimating];
	}
	_activityCount++;
}

- (void)stopAnimating {
	if (_activityCount > 0) {
		_activityCount--;
	}
	if (_activityCount == 0) {
		[_childIndicator stopAnimating];
		if (_hidesWhenStopped && self.superview) [self removeFromSuperview];
	}
}

- (BOOL)isAnimating {
	return [_childIndicator isAnimating];
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
	return _childIndicator.activityIndicatorViewStyle;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
	_childIndicator.activityIndicatorViewStyle = style;
}

@end
