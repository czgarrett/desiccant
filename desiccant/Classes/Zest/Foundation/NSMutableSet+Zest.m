//
//  NSMutableSet+Zest.m
//  word-game-3
//
//  Created by Garrett Christopher on 1/11/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "NSMutableSet+Zest.h"

@implementation NSMutableSet (Zest)

- (BOOL) addObjectUnlessNil: (id) object {
   if (object) {
      [self addObject: object];
      return YES;
   } else {
      return NO;
   }
}


@end
