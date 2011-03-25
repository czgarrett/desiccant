//
//  UITableView+Zest.m
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UITableView+Zest.h"

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

@end


@interface FixCategoryBugUITableView : NSObject {}
@end
@implementation FixCategoryBugUITableView
@end