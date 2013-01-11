//
//  NSNull+Zest.m
//  BlueDevils
//
//  Created by Curtis Duhn on 2/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSNull+Zest.h"


@implementation NSNull (Zest)

- (NSString *)toS {
    return nil;
}

- (NSInteger)toI {
    return 0;
}

- (NSURL *)toURL {
    return nil;
}

- (NSDate *)toDate {
    return nil;
}

- (NSNumber *)toN {
    return nil;
}

@end


@interface FixCategoryBugNSNull : NSObject {}
@end
@implementation FixCategoryBugNSNull
@end
