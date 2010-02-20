//
//  NSNull+Zest.m
//  BlueDevils
//
//  Created by Curtis Duhn on 2/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSNull+Zest.h"


@implementation NSNull (Zest)

- (NSString *)to_s {
    return nil;
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

- (NSNumber *)to_n {
    return nil;
}

@end
