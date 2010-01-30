//
//  NSArray+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor ( Zest )

+ (UIColor *)transparentColor;

// Creates a color from an array of NSNumber objects containing red, green, blue, and alpha values.  This MUST be a four-value array or nil.
// Nil will return [UIColor blackColor];
+ (UIColor *)colorWithRGBArray:(NSArray *)values;

// Creates a color from an array of NSNumber objects containing red, green, blue, and alpha values.  This MUST be a four-value array or nil.
// Nil will return [UIColor blackColor];
- (UIColor *)initWithRGBArray:(NSArray *)values;


@end
