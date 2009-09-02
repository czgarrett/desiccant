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

@end
