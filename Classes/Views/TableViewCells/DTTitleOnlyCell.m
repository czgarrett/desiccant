//
//  ACNewsCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/25/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTitleOnlyCell.h"
#import "Zest.h"

@implementation DTTitleOnlyCell
@synthesize title;

- (void)dealloc {
    self.title = nil;
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    self.title.text = [data stringForKey:@"title"];
	if ([self hasDynamicHeight]) {
		[self adjustHeightForLabel:self.title];
	}
}


@end
