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
// Returns the ancestor from the view hierarchy that is a UITableViewCell, if one exists, or nil otherwise.
@property (nonatomic, retain, readonly) UITableViewCell *tableViewCell;

// Sets self.frame to be the same as the specified view's frame, and adds self as a subview of its superview
- (void)overlayView:(UIView *)view;

// Returns the ancestor from the view hierarchy that has the specified class, if one exists, or nil otherwise.
- (UIView *)ancestorWithClass:(Class)ancestorClass;

@end
