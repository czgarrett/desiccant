//
//  UIFont+ZestCoreText.m
//  blush
//
//  Created by Garrett Christopher on 12/21/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "UIFont+ZestCoreText.h"

@implementation UIFont (ZestCoreText)

- (CTFontRef) CTFontCreate {
   CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.fontName, 
                                           self.pointSize, 
                                           NULL);
   return ctFont;
}

@end
