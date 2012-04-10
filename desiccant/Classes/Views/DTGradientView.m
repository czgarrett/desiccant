//
//  DTGradientView.m
//  GrabNGo
//
//  Created by Curtis Duhn on 6/9/11.
//  Copyright 2011 ZWorkbench, Inc.. All rights reserved.
//

#import "DTGradientView.h"

@interface DTGradientView()
- (NSArray *)defaultLocationsForColors:(NSArray *)colors;
- (NSArray *)colorsToCGColors:(NSArray *)colors;
@end

@implementation DTGradientView

#pragma mark Memory management

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark UIView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

#pragma mark Dynamic properties

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

#pragma mark Public

- (void)setColors:(NSArray *)colors {
    [self setColors:colors startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0) locationsArray: [self defaultLocationsForColors:colors]];
}

- (void)setColors:(NSArray *)colors locations:(CGFloat)firstLocation, ... {
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
    
    [self setColors:colors startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0) locationsArray:locationsArray];
}

- (void)setColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(CGFloat)firstLocation, ... {
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
    
    [self setColors:colors startPoint:startPoint endPoint:endPoint locationsArray:locationsArray];
}

- (void)setColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locationsArray:(NSArray *)locationsArray {
    self.gradientLayer.colors = [self colorsToCGColors:colors];
    self.gradientLayer.startPoint = startPoint;
    self.gradientLayer.endPoint = endPoint;
    self.gradientLayer.locations = locationsArray;
}

#pragma mark Private

- (NSArray *)defaultLocationsForColors:(NSArray *)colors {
    NSInteger numElements = [colors count];
    NSMutableArray *locationsArray = [NSMutableArray arrayWithCapacity:numElements];
    CGFloat interval = 1.0 / (numElements - 1);
    for (NSInteger i = 0; i < numElements; i++) {
        CGFloat location = i * interval;
        [locationsArray addObject:[NSNumber numberWithFloat:location]];
    }
    return locationsArray;
}

- (NSArray *)colorsToCGColors:(NSArray *)colors {
    NSInteger numElements = [colors count];
    NSMutableArray *cgcolorsArray = [NSMutableArray arrayWithCapacity:numElements];
    for (UIColor *color in colors) {
        [cgcolorsArray addObject:(id)color.CGColor];
    }
    return cgcolorsArray;
}

@end
