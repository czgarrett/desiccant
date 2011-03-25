//
//  NSNumber+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSNumber+Zest.h"


@implementation NSNumber(Zest)

- (NSString *)to_s {
    return [self stringValue];
}

- (NSInteger) to_i {
    return [self integerValue];
}

- (NSDate *)to_date {
    return [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
}

- (NSNumber *)to_n {
    return self;
}


@end


@interface FixCategoryBugNSNumber : NSObject {}
@end
@implementation FixCategoryBugNSNumber
@end