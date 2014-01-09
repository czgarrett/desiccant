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
    if ((self = [self initWithFrame:CGRectZero])) {
        self.text = newText;
    }
    return self;
}

+ (UILabel *)labelWithText:(NSString *)text {
    return [[self alloc] initWithText:text];
}

- (CGFloat)heightToFitText {
	NSAssert (self.bounds.size.width > 0, @"Warning: This method depends on the label having a nonzero width when called.");
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = self.lineBreakMode;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraph,
                                 NSFontAttributeName: self.font};
    CGSize boundingSize = CGSizeMake(self.bounds.size.width, [self maxHeight]);
    CGSize size = [self.text boundingRectWithSize: boundingSize
                                   options: 0
                                attributes: attributes
                                   context: nil].size;
    return ceilf(size.height);
}

- (CGFloat) currentTextWidth {
   NSAssert(self.numberOfLines == 1, @"This method should only be called on a label with one line of text");
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = self.lineBreakMode;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraph,
                                 NSFontAttributeName: self.font};
    return [self.text boundingRectWithSize: self.bounds.size
                                   options: 0
                                attributes: attributes
                                   context: nil].size.width;
}


- (void) alignTop {
   self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self heightToFitText]);
}

- (CGFloat)lineHeight {
	return [self.font ascender] - [self.font descender] + 1;
}

- (NSInteger)numberOfLinesToFitText {
	return (NSInteger)([self heightToFitText] / [self lineHeight]);
}

- (CGFloat)maxHeight {
	return self.numberOfLines > 0 ? [self lineHeight] * self.numberOfLines : CGFLOAT_MAX;
}

@end


@interface FixCategoryBugUILabel : NSObject {}
@end
@implementation FixCategoryBugUILabel
@end