//
//  UIButton+Zest.m
//
//  Created by Curtis Duhn on 11/16/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UIButton+Zest.h"


@implementation UIButton (Zest)

//- (void)dealloc {
//    [super dealloc];
//}

+ (UIButton *)darkGrayButton {
	return [self buttonWithNormalImage:[UIImage imageNamed:@"darkGrayKey.png"] 
								selectedImage:[UIImage imageNamed:@"lightGrayKey.png"] 
								 leftCapWidth:5 
								 topCapHeight:15 
							 normalTextColor:[UIColor whiteColor]
						  selectedTextColor:[UIColor darkGrayColor]
						  normalShadowColor:[UIColor darkGrayColor]
						selectedShadowColor:[UIColor whiteColor]];
}

+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage 
							 selectedImage:(UIImage *)selectedImage 
							  leftCapWidth:(NSInteger)leftCapWidth 
							  topCapHeight:(NSInteger)topCapHeight 
						  normalTextColor:(UIColor *)normalTextColor
						selectedTextColor:(UIColor *)selectedTextColor
						normalShadowColor:(UIColor *)normalShadowColor
					 selectedShadowColor:(UIColor *)selectedShadowColor 
{
	UIButton *button  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setBackgroundImage:[normalImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight] forState:UIControlStateNormal];
	[button setBackgroundImage:[selectedImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight] forState:UIControlStateHighlighted];
	[button setTitleColor:normalTextColor forState:UIControlStateNormal];
	[button setTitleColor:selectedTextColor forState:UIControlStateHighlighted];
	[button setTitleShadowColor:normalShadowColor forState:UIControlStateNormal];
	[button setTitleShadowColor:selectedShadowColor forState:UIControlStateHighlighted];
	[button.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
	return button;
}

@end
