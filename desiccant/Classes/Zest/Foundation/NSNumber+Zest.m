//
//  NSNumber+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSNumber+Zest.h"


@implementation NSNumber(Zest)

- (NSString *)toS {
    return [self stringValue];
}

- (NSInteger)toI {
    return [self integerValue];
}

- (NSDate *)toDate {
    return [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
}

- (NSNumber *)toN {
    return self;
}


@end


@interface FixCategoryBugNSNumber : NSObject {}
@end
@implementation FixCategoryBugNSNumber
@end