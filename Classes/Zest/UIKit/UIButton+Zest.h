//
//  UIButton+Zest.h
//
//  Created by Curtis Duhn on 11/16/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Zest)

+ (UIButton *)darkGrayButton;

+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage 
							 selectedImage:(UIImage *)selectedImage 
							  leftCapWidth:(NSInteger)leftCapWidth 
							  topCapHeight:(NSInteger)topCapHeight 
						  normalTextColor:(UIColor *)normalTextColor
						selectedTextColor:(UIColor *)selectedTextColor
						normalShadowColor:(UIColor *)normalShadowColor
					 selectedShadowColor:(UIColor *)selectedShadowColor;

@end
