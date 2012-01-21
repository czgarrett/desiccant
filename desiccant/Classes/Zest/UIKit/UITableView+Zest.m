//
//  UITableView+Zest.m
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UITableView+Zest.h"
#import <QuartzCore/QuartzCore.h>

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
   UIColor *shadowStartColor = [UIColor colorWithWhite: 0.0 alpha: 0.2];
   UIView *topShadowView = [[UIView alloc] initWithFrame: CGRectMake(self.bounds.origin.x, 
                                                                      self.bounds.origin.y, 
                                                                      1024,  // to support resizing all the way up to ipad
                                                                      self.bounds.size.height/2)];
   topShadowView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
   CAGradientLayer *topGradient = [[CAGradientLayer alloc] init];
   NSMutableArray *colors = [NSMutableArray array];
   [colors addObject: (id)shadowStartColor.CGColor];
   [colors addObject: (id)[UIColor clearColor].CGColor];
   topGradient.colors = colors;
   topGradient.frame = topShadowView.bounds;
   [topShadowView.layer addSublayer: topGradient];
   
   UIView *bottomShadowView = [[UIView alloc] initWithFrame: CGRectMake(self.bounds.origin.x, 
                                                                         self.bounds.origin.y + self.bounds.size.height - self.bounds.size.height/2, 
                                                                         1024, 
                                                                         self.bounds.size.height/2)];
   bottomShadowView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
   CAGradientLayer *bottomGradient = [[CAGradientLayer alloc] init];
   [colors removeAllObjects];
   [colors addObject: (id)[UIColor clearColor].CGColor];
   [colors addObject: (id)shadowStartColor.CGColor];
   bottomGradient.colors = colors;
   bottomGradient.frame = bottomShadowView.bounds;
   [bottomShadowView.layer addSublayer: bottomGradient];
   
   UIView *shadowView = [[UIView alloc] initWithFrame: self.frame];
   shadowView.userInteractionEnabled = NO;
   shadowView.autoresizingMask = self.autoresizingMask;
   shadowView.clipsToBounds = YES;
   [shadowView addSubview: topShadowView];
   [shadowView addSubview: bottomShadowView];
   [[self superview] addSubview: shadowView];
}


@end


@interface FixCategoryBugUITableView : NSObject {}
@end
@implementation FixCategoryBugUITableView
@end