//
//  UIScreen+Zest.m
//  BlueDevils
//
//  Created by Curtis Duhn on 4/1/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "UIScreen+Zest.h"

@implementation UIScreen(Zest)

- (CGPoint)center {
	// TODO: Test this in landscape mode
	return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (CGFloat) bcompat_scale {
	if ([self respondsToSelector: @selector(scale)]) {
		return [self scale];
	}
	else {
		return 1.0;
	}
}

- (BOOL) is2X {
   return self.bcompat_scale > 1.99 && self.bcompat_scale < 2.01;
}

@end



@interface FixCategoryBugUIScreen : NSObject {}
@end
@implementation FixCategoryBugUIScreen
@end