//
//  UILabel+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UILabel+Zest.h"


@implementation UILabel (Zest)

- (id)initWithText:(NSString *)newText {
    if (self = [self initWithFrame:CGRectZero]) {
        self.text = newText;
    }
    return self;
}

+ (UILabel *)labelWithText:(NSString *)text {
    return [[[self alloc] initWithText:text] autorelease];
}

- (CGFloat)heightToFitText {
	return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, [self lineHeight] * self.numberOfLines) lineBreakMode:self.lineBreakMode].height;
}

- (CGFloat)lineHeight {
//	CGFloat spaceHeight = [@" " sizeWithFont:self.font constrainedToSize:CGSizeMake(9999.0, 9999.0) lineBreakMode:self.lineBreakMode].height;
//	CGFloat xHeight = [@"x" sizeWithFont:self.font constrainedToSize:CGSizeMake(9999.0, 9999.0) lineBreakMode:self.lineBreakMode].height;
//	CGFloat emHeight = [@"M" sizeWithFont:self.font constrainedToSize:CGSizeMake(9999.0, 9999.0) lineBreakMode:self.lineBreakMode].height;
//	CGFloat twoLineEmHeight = [@"M\nM" sizeWithFont:self.font constrainedToSize:CGSizeMake(9999.0, 9999.0) lineBreakMode:self.lineBreakMode].height;
	return [self.font ascender] - [self.font descender] + 1;
//	return [@"MyText" sizeWithFont:self.font constrainedToSize:CGSizeMake(9999.0, 9999.0) lineBreakMode:self.lineBreakMode].height;
}

@end
