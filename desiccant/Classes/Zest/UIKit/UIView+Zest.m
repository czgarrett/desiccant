//
//  UIView+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UIView+Zest.h"
#import "UIColor+Zest.h"

@implementation UIView (Zest)

- (UIView *)rootView {
    if (!self.superview) return self;
    else return self.superview.rootView;
}

- (void)overlayView:(UIView *)view {
    self.frame = view.frame;
    if (view.superview) {
        [view.superview addSubview:self];
    }
}

// Returns the ancestor from the view hierarchy that is a UITableViewCell, if one exists, or nil otherwise.
- (UITableViewCell *)tableViewCell {
	return (UITableViewCell *)[self ancestorWithClass:UITableViewCell.class];
}

// Returns the ancestor from the view hierarchy that has the specified class, if one exists, or nil otherwise.
- (UIView *)ancestorWithClass:(Class)ancestorClass {
	if (self.superview == nil) return nil;
	else if ([self.superview isKindOfClass:ancestorClass]) return self.superview;
	else return [self.superview ancestorWithClass:ancestorClass];
}

- (UIView *) descendentWithClass:(Class)descendentClass {
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass: descendentClass]) {
            return view;
        } else {
            UIView *descendent = [view descendentWithClass: descendentClass];
            if (descendent) {
                return descendent;
            }
        }
    }
    NSLog(@"%@ is not a %@", [self class], descendentClass);
    return nil;
}

- (UIView *)findFirstResponder { 
   if ([self isFirstResponder]) { 
      return self; 
   } 
   for (UIView *subView in self.subviews) { 
      UIView *firstResponder = [subView findFirstResponder]; 
      if (firstResponder != nil) { 
         return firstResponder; 
      } 
   } 
   return nil; 
} 

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)theHeight {
	CGRect myFrame = self.frame;
	myFrame.size.height = theHeight;
	self.frame = myFrame;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)theWidth {
	CGRect myFrame = self.frame;
	myFrame.size.width = theWidth;
	self.frame = myFrame;
}

- (CGFloat)x {
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)theX {
	CGRect myFrame = self.frame;
	myFrame.origin.x = theX;
	self.frame = myFrame;
}

- (CGFloat)y {
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)theY {
	CGRect myFrame = self.frame;
	myFrame.origin.y = theY;
	self.frame = myFrame;
}

- (CGFloat)cornerRadius {
	return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
	if (radius > 0) self.layer.masksToBounds = YES;
}

- (CGFloat)borderWidth {
	return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
	self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
	return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
	self.layer.borderColor = borderColor.CGColor;
}

- (void)removeAllSubviews {
	for (UIView *subview in self.subviews) {
		[subview removeFromSuperview];
	}
}

@end


@interface FixCategoryBugUIView : NSObject {}
@end
@implementation FixCategoryBugUIView
@end