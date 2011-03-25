//
//  UIScrollView+Zest.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "UIScrollView+Zest.h"



@implementation UIScrollView(Zest)

- (NSInteger)currentHorizontalPage {
	CGFloat pageSize = self.bounds.size.width;
	CGFloat offsetToCenter = self.contentOffset.x + (pageSize / 2);
	return offsetToCenter / pageSize;
}

- (NSInteger)currentVerticalPage {
	CGFloat pageSize = self.bounds.size.height;
	CGFloat offsetToCenter = self.contentOffset.y + (pageSize / 2);
	return offsetToCenter / pageSize;
}

@end


@interface FixCategoryBugUIScrollView : NSObject {}
@end
@implementation FixCategoryBugUIScrollView
@end