//
//  UIView+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

@import Foundation;
@import UIKit;
@import QuartzCore;

@interface UIView (Zest)

// Recursively finds the root of the view hierarchy
@property (nonatomic, retain, readonly) UIView *rootView;
// Returns the ancestor from the view hierarchy that is a UITableViewCell, if one exists, or nil otherwise.
@property (nonatomic, retain, readonly) UITableViewCell *tableViewCell;
// Sets or returns view's frame.size.height
@property (nonatomic) CGFloat height;
// Sets or returns view's frame.size.width
@property (nonatomic) CGFloat width;
// Sets or returns view's frame.origin.x
@property (nonatomic) CGFloat x;
// Sets or returns view's frame.origin.y
@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, copy) UIColor *borderColor;

// Sets self.frame to be the same as the specified view's frame, and adds self as a subview of its superview
- (void)overlayView:(UIView *)view;

// Returns the ancestor from the view hierarchy that has the specified class, if one exists, or nil otherwise.
- (UIView *)ancestorWithClass:(Class)ancestorClass;
- (UIView *)descendentWithClass:(Class)descendentClass;

// Recursively searches the view hierarchy for the first responder
- (UIView *)findFirstResponder;


- (void)removeAllSubviews;

@end
