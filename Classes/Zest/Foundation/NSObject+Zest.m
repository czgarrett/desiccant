//
//  NSObject+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSObject+Zest.h"


@implementation NSObject (Zest)

- (NSString *)to_s {
    return [self description];
}

- (NSInteger)to_i {
    return 0;
}

- (NSURL *)to_url {
    return nil;
}

- (NSDate *)to_date {
    return nil;
}

@end
