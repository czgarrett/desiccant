//
//  UIView+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UIView+Zest.h"


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

@end
