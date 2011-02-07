//
//  NSTimeZone+Zest.m
//  RedRover
//
//  Created by Christopher Garrett on 2/7/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSTimeZone+Zest.h"


@implementation NSTimeZone (Zest)

- (NSInteger) minutesFromGMT {
   return [self secondsFromGMT] / 60;
}

@end
