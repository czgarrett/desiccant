//
//  NSIndexPath+Zest.m
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSIndexPath+Zest.h"


@implementation NSIndexPath (Zest)

- (NSIndexPath *)relativeIndexPathWithBaseSection:(NSUInteger)baseSection andBaseRow:(NSUInteger)baseRow {
	NSAssert2 (self.section >= baseSection, @"Requested relative index path given base section %lu, which is greater than absolute section %lu", (unsigned long) baseSection, (unsigned long) self.section);
	NSAssert3 (self.section != baseSection || self.row >= baseRow, @"Requested relative index path given a base section equal to the absolute section %lu, and a base row %lu greater than the absolute section %lu", (unsigned long) baseSection, (unsigned long) baseRow, (unsigned long) self.row);
	NSUInteger newSection = self.section - baseSection;
	NSUInteger newRow;
	if (self.section == baseSection) newRow = self.row - baseRow;
	else newRow = self.row;
	return [NSIndexPath indexPathForRow:newRow inSection:newSection];
}

@end


@interface FixCategoryBugNSIndexPath : NSObject {}
@end
@implementation FixCategoryBugNSIndexPath
@end