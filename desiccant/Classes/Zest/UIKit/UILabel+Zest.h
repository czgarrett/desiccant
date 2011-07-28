//
//  UILabel+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (Zest)

- (id)initWithText:(NSString *)newText;
+ (UILabel *)labelWithText:(NSString *)text;
- (CGFloat)heightToFitText;
- (CGFloat)lineHeight;
- (NSInteger)numberOfLinesToFitText;
- (CGFloat)maxHeight;
- (void) alignTop;
// For single line labels
- (CGFloat) currentTextWidth;


@end
