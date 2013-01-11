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
@synthesize titleLabel, dataDictionary;

- (void)dealloc {
    self.titleLabel = nil;
	self.dataDictionary = nil;
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)theData {
	self.dataDictionary = theData;
    self.titleLabel.text = [theData stringForKey:@"title"];
	if ([self hasDynamicHeight]) {
		[self adjustHeightForLabel:self.titleLabel];
	}
}


@end
