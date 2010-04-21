//
//  DTActivityIndicatorView.m
//  PortablePTO
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTActivityIndicatorView.h"


@interface DTActivityIndicatorView()
@property (nonatomic, retain) UIActivityIndicatorView *childIndicator;
@end

@implementation DTActivityIndicatorView
@synthesize childIndicator, hidesWhenStopped;

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
		hidesWhenStopped = YES;
		activityCount = 0;
	}
	return self;
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
