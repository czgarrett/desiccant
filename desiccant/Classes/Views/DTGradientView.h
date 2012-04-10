//
//  DTGradientView.h
//  GrabNGo
//
//  Created by Curtis Duhn on 6/9/11.
//  Copyright 2011 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DTGradientView : UIView {
    
}
@property (nonatomic, retain, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;
- (void)setColors:(NSArray *)colors locations:(CGFloat)firstLocation, ...;
- (void)setColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(CGFloat)firstLocation, ...;
- (void)setColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locationsArray:(NSArray *)locationsArray;

@end
