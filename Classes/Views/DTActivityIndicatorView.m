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
@end

static DTActivityIndicatorStyle defaultStyle;

@implementation DTActivityIndicatorView
@synthesize childIndicator, hidesWhenStopped, dtActivityIndicatorStyle;

+ (void) setDefaultStyle: (DTActivityIndicatorStyle) style {
   defaultStyle = style;
}

- (void)dealloc {
	self.childIndicator = nil;
    [super dealloc];
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
	UIActivityIndicatorView *newIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style] autorelease];
	if (self = [super initWithFrame:newIndicator.frame]) {
		newIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		newIndicator.hidesWhenStopped = NO;
		self.childIndicator = newIndicator;
		[self addSubview:childIndicator];
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
         self.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
         self.layer.cornerRadius = 10.0;
         self.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.5];
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
