//
//  UITableView+Zest.m
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UITableView+Zest.h"
#import <QuartzCore/QuartzCore.h>
#define INNER_SHADOW_HEIGHT 10.0

@implementation UITableView(Zest)

- (NSInteger) numberOfRowsAcrossAllSections {
	NSInteger numberOfRows = 0;
	for (NSInteger section = 0; section < [self numberOfSections]; section++) {
		numberOfRows += [self numberOfRowsInSection:section];
	}
	return numberOfRows;
}

- (CGFloat) cellWidth {
	return (self.style == UITableViewStyleGrouped) ? self.frame.size.width - 20.0 : self.frame.size.width;
}

- (void) addInnerShadow {
   UIColor *shadowStartColor = [UIColor colorWithWhite: 0.0 alpha: 0.6];
   UIView *topShadowView = [[[UIView alloc] initWithFrame: CGRectMake(self.bounds.origin.x, 
                                                                      self.bounds.origin.y, 
                                                                      self.bounds.size.width, 
                                                                      INNER_SHADOW_HEIGHT)] autorelease];
   topShadowView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
   CAGradientLayer *topGradient = [[[CAGradientLayer alloc] init] autorelease];
   NSMutableArray *colors = [NSMutableArray array];
   [colors addObject: (id)shadowStartColor.CGColor];
   [colors addObject: (id)[UIColor clearColor].CGColor];
   topGradient.colors = colors;
   topGradient.frame = topShadowView.bounds;
   [topShadowView.layer addSublayer: topGradient];

   UIView *bottomShadowView = [[[UIView alloc] initWithFrame: CGRectMake(self.bounds.origin.x, 
                                                                      self.bounds.origin.y + self.bounds.size.height - INNER_SHADOW_HEIGHT, 
                                                                      self.bounds.size.width, 
                                                                      INNER_SHADOW_HEIGHT)] autorelease];
   bottomShadowView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
   CAGradientLayer *bottomGradient = [[[CAGradientLayer alloc] init] autorelease];
   [colors removeAllObjects];
   [colors addObject: (id)[UIColor clearColor].CGColor];
   [colors addObject: (id)shadowStartColor.CGColor];
   bottomGradient.colors = colors;
   bottomGradient.frame = bottomShadowView.bounds;
   [bottomShadowView.layer addSublayer: bottomGradient];


   UIView *shadowView = [[[UIView alloc] initWithFrame: self.frame] autorelease];
   shadowView.userInteractionEnabled = NO;
   shadowView.autoresizingMask = self.autoresizingMask;
   [shadowView addSubview: topShadowView];
   [shadowView addSubview: bottomShadowView];
   //shadowView.backgroundColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 0.2];
   [[self superview] addSubview: shadowView];
}

@end


@interface FixCategoryBugUITableView : NSObject {}
@end
@implementation FixCategoryBugUITableView
@end