//
//  NSData+Zest.m
//
//  Created by Curtis Duhn on 11/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSData+Zest.h"


@implementation NSData(Zest)

- (NSData *)nullTerminated {
	return [[NSMutableData dataWithData:self] nullTerminated];
}

@end
