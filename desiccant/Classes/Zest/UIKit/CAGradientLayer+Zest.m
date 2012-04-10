//
//  CAGradientLayer+Zest.m
//  GrabNGo
//
//  Created by Curtis Duhn on 6/8/11.
//  Copyright 2011 ZWorkbench, Inc.. All rights reserved.
//

#import "CAGradientLayer+Zest.h"

NSArray * defaultLocationsForColors(NSArray *colors) {
    NSInteger numElements = [colors count];
    NSMutableArray *locationsArray = [NSMutableArray arrayWithCapacity:numElements];
    CGFloat interval = 1.0 / (numElements - 1);
    for (NSInteger i = 0; i < numElements; i++) {
        CGFloat location = i * interval;
        [locationsArray addObject:[NSNumber numberWithFloat:location]];
    }
    return locationsArray;
}

NSArray * colorsToCGColors(NSArray *colors) {
    NSInteger numElements = [colors count];
    NSMutableArray *cgcolorsArray = [NSMutableArray arrayWithCapacity:numElements];
    for (UIColor *color in colors) {
        [cgcolorsArray addObject:(id)color.CGColor];
    }
    return cgcolorsArray;
}
                           
@implementation CAGradientLayer (Zest)

// Constructs a vertical gradient with colors evenly distributed along the  y axis.
+ (id)verticalGradientWithColors:(NSArray *)colors {
    return [CAGradientLayer linearGradientWithColors:colors startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0) locationsArray: defaultLocationsForColors(colors)];
}

// Constructs a vertical gradient with the specified colors and locations
+ (id)verticalGradientWithColors:(NSArray *)colors locations:(CGFloat)firstLocation, ... {
    
    NSInteger numElements = [colors count];
    NSMutableArray *locationsArray = [NSMutableArray arrayWithCapacity:numElements];
    va_list args;
    for (NSInteger i = 0; i < numElements; i++) {
        double location;
        if (i == 0) {
            va_start(args, firstLocation);
            location = firstLocation;
        }
        else {
            location = va_arg(args, double);
        }
        [locationsArray addObject:[NSNumber numberWithFloat:location]];
    }
    va_end(args);
    
    return [CAGradientLayer linearGradientWithColors:colors startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0) locationsArray:locationsArray];
}

// Constructs a linear gradient with the specified colors, locations, startPoint, and endPoint.
+ (id)linearGradientWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(CGFloat)firstLocation, ... {
    NSInteger numElements = [colors count];
    NSMutableArray *locationsArray = [NSMutableArray arrayWithCapacity:numElements];
    va_list args;
    for (NSInteger i = 0; i < numElements; i++) {
        double location;
        if (i == 0) {
            va_start(args, firstLocation);
            location = firstLocation;
        }
        else {
            location = va_arg(args, double);
        }
        [locationsArray addObject:[NSNumber numberWithFloat:location]];
    }
    va_end(args);
    
    return [CAGradientLayer linearGradientWithColors:colors startPoint:startPoint endPoint:endPoint locationsArray:locationsArray];
}

// Constructs a linear gradient with the specified colors, locations, startPoint, and endPoint.
+ (id)linearGradientWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locationsArray:(NSArray *)locationsArray {
    CAGradientLayer *layer = [[[CAGradientLayer alloc] init] autorelease];
    layer.colors = colorsToCGColors(colors);
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    layer.locations = locationsArray;
    return layer;
}

@end
