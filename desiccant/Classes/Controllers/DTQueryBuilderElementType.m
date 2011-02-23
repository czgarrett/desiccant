//
//  DTQueryBuilderElementType.m
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTQueryBuilderElementType.h"


@interface DTQueryBuilderElementType()
@end

@implementation DTQueryBuilderElementType
@synthesize labelText, selectorText;

- (void)dealloc {
	self.labelText = nil;
	self.selectorText = nil;
	
	[super dealloc];
}

@end
