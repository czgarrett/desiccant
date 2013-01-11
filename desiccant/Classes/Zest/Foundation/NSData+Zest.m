//
//  NSData+Zest.m
//
//  Created by Curtis Duhn on 11/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSData+Zest.h"
#import "NSString+Zest.h"
#import "CBucks.h"
#import "NSMutableData+Zest.h"

@implementation NSData(Zest)

- (NSData *)nullTerminated {
	return [[NSMutableData dataWithData:self] terminateWithNull];
}

- (NSString *)toS {
	NSString *response = [NSString stringWithData:self encoding:NSUTF8StringEncoding];
	if (!response) response = [NSString stringWithData:self encoding:NSISOLatin1StringEncoding];
	if (!response) response = $S(@"%@ (Could not be parsed as UTF-8 or Latin1.)", [super description]);
	return response;
}

@end


@interface FixCategoryBugNSData : NSObject {}
@end
@implementation FixCategoryBugNSData
@end