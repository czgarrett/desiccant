//
//  TestException.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/16/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestException.h"


@implementation TestException
+(TestException *) exceptionWithReason: (NSString *)reason
{
   TestException *result = [[TestException alloc] initWithName:@"Test Failed" reason: reason userInfo: nil];
   [result autorelease];
   return result;
}

@end
