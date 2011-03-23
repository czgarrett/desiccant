//
//  NSMutableData+Zest.m
//
//  Created by Curtis Duhn on 11/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSMutableData+Zest.h"


@implementation NSMutableData (Zest)

- (NSMutableData *)terminateWithNull {
	if (((char *)[self bytes])[[self length] - 1] != 0) {
		char c = 0;
		[self appendBytes:&c length:1];
	}
	return self;
}

@end
