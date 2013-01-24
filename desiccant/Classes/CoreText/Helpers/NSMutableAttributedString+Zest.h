//
//  NSMutableAttributedString+Zest.h
//  blush
//
//  Created by Garrett Christopher on 12/21/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (Zest)

+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment;
+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment firstLineIndent:(CGFloat)firstLineIndent hangingIndent:(CGFloat)hangingIndent;
+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment firstLineIndent:(CGFloat)firstLineIndent hangingIndent:(CGFloat)hangingIndent tabInterval:(CGFloat)tabInterval;

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight;
- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth;

@end
