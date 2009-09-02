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
    if (!self.superview) {
        return self;
    }
    else {
        return self.superview.rootView;
    }
}

- (void)overlayView:(UIView *)view {
    self.frame = view.frame;
    if (view.superview) {
        [view.superview addSubview:self];
    }
}

@end
