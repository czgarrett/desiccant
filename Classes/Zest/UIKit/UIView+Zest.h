//
//  UIView+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Zest)

// Recursively finds the root of the view hierarchy
@property (nonatomic, retain, readonly) UIView *rootView;

// Sets self.frame to be the same as the specified view's frame, and adds self as a subview of its superview
- (void)overlayView:(UIView *)view;

@end
