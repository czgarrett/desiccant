//
//  NSURLResponse+Zest.m
//
//  Created by Curtis Duhn on 1/22/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSURLResponse+Zest.h"


@implementation NSURLResponse (Zest)

- (NSError *)httpError {
	return nil;
}

- (NSString *)httpContentType {
	return nil;
}

@end

@interface FixCategoryBugNSURLResponse : NSObject {}
@end
@implementation FixCategoryBugNSURLResponse
@end