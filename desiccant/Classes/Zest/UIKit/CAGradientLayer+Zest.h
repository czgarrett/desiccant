//
//  CAGradientLayer+Zest.h
//  GrabNGo
//
//  Created by Curtis Duhn on 6/8/11.
//  Copyright 2011 ZWorkbench, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (Zest)

// Constructs a vertical gradient with colors evenly distributed along the  y axis.
+ (id)verticalGradientWithColors:(NSArray *)colors;

// Constructs a vertical gradient with the specified colors and locations
+ (id)verticalGradientWithColors:(NSArray *)colors locations:(CGFloat)firstLocation, ...;

// Constructs a linear gradient with the specified colors, locations, startPoint, and endPoint.
+ (id)linearGradientWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(CGFloat)firstLocation, ...;

// Constructs a linear gradient with the specified colors, locations, startPoint, and endPoint.
+ (id)linearGradientWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locationsArray:(NSArray *)locationsArray;

@end
