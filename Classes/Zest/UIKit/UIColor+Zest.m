//
//  NSArray+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "UIColor+Zest.h"

@implementation UIColor ( Zest )

+ (UIColor *)colorWithRGBArray:(NSArray *)values {
   if (values) {
      return [UIColor colorWithRed: [[values objectAtIndex: 0] floatValue]
                             green: [[values objectAtIndex: 1] floatValue]
                              blue: [[values objectAtIndex: 2] floatValue]
                             alpha: [[values objectAtIndex: 3] floatValue]];
   } else {
      return [UIColor blackColor];
   }
}

- (UIColor *)initWithRGBArray:(NSArray *)values {
   if (values) {
      return [self     initWithRed: [[values objectAtIndex: 0] floatValue]
                             green: [[values objectAtIndex: 1] floatValue]
                              blue: [[values objectAtIndex: 2] floatValue]
                             alpha: [[values objectAtIndex: 3] floatValue]];
   } else {
      return [self initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
   }
}


@end
