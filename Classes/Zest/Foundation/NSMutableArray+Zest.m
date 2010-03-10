//
//  NSArray+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSMutableArray+Zest.h"
#import "Zest.h"

@implementation NSMutableArray ( Zest )

- (void) addObjectUnlessNil: (NSObject *) object {
   if (object != nil) {
      [self addObject: object];
   }
}


- (id) pop {
   id result = [self lastObject];
   [result retain];
   [result autorelease];
   [self removeLastObject];
   return result;
}


@end
