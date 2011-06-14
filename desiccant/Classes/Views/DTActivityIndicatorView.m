//
//  DTActivityIndicatorView.m
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>


@interface DTActivityIndicatorView()
@property (nonatomic, retain) UIActivityIndicatorView *childIndicator;
@property (nonatomic, retain) UIView *childIndicatorBackground;
@end

static DTActivityIndicatorStyle defaultStyle;

@implementation DTActivityIndicatorView
@synthesize childIndicator, hidesWhenStopped, dtActivityIndicatorStyle, childIndicatorBackground;

+ (void) setDefaultStyle: (DTActivityIndicatorStyle) style {
   defaultStyle = style;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
	UIActivityIndicatorView *newIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	if ((self = [super initWithFrame: CGRectMake(0.0, 0.0, 300.0, 300.0)])) {
		newIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		newIndicator.hidesWhenStopped = NO;
		self.childIndicator = newIndicator;
      
      self.childIndicatorBackground = [[UIView alloc] initWithFrame: CGRectMake(100.0, 100.0, 100.0, 100.0)];
      self.childIndicatorBackground.layer.cornerRadius = 10.0;
		self.childIndicatorBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
      
		[self.childIndicatorBackground addSubview:childIndicator];
      [self addSubview: self.childIndicatorBackground];
      childIndicator.center = CGPointMake(50.0, 50.0);
      self.dtActivityIndicatorStyle = defaultStyle;
		hidesWhenStopped = YES;
		activityCount = 0;
	}
	return self;
}

- (void) setDtActivityIndicatorStyle: (DTActivityIndicatorStyle) style {
   dtActivityIndicatorStyle = style;
   switch (dtActivityIndicatorStyle) {
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
	if (activityCount == 0) {
		[childIndicator startAnimating];
	}
	activityCount++;
}

- (void)stopAnimating {
	if (activityCount > 0) {
		activityCount--;
	}
	if (activityCount == 0) {
		[childIndicator stopAnimating];
		if (hidesWhenStopped && self.superview) [self removeFromSuperview];
	}
}

- (BOOL)isAnimating {
	return [childIndicator isAnimating];
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
	return childIndicator.activityIndicatorViewStyle;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
	childIndicator.activityIndicatorViewStyle = style;
}

@end
