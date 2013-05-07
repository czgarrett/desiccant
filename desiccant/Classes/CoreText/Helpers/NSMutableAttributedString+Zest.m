//
//  NSMutableAttributedString+Zest.m
//  blush
//
//  Created by Garrett Christopher on 12/21/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSMutableAttributedString+Zest.h"
#import "UIFont+ZestCoreText.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (Zest)

+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment

{
   CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
   
   if (string != nil)
      CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)string);
   
   CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTForegroundColorAttributeName, color.CGColor);
   CTFontRef theFont = [font CTFontCreate];
   CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, theFont);
   CFRelease(theFont);
   
   CTParagraphStyleSetting settings[] = {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment};
   CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
   CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTParagraphStyleAttributeName, paragraphStyle);    
   CFRelease(paragraphStyle);
      
   NSMutableAttributedString *ret = (NSMutableAttributedString *)CFBridgingRelease(attrString);
   
    return ret;
}

+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment firstLineIndent:(CGFloat)firstLineIndent hangingIndent:(CGFloat)hangingIndent
{
   CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
   
   if (string != nil)
      CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)string);
      
      CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTForegroundColorAttributeName, color.CGColor);
      
      CTFontRef theFont = [font CTFontCreate];
      CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, theFont);
      CFRelease(theFont);
    
      CTParagraphStyleSetting settings[] = {
         {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
         {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(firstLineIndent), &firstLineIndent},
         {kCTParagraphStyleSpecifierHeadIndent, sizeof(hangingIndent), &hangingIndent}
      };
      CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
      CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTParagraphStyleAttributeName, paragraphStyle);    
      CFRelease(paragraphStyle);
      
      NSMutableAttributedString *ret = (NSMutableAttributedString *)CFBridgingRelease(attrString);
      
      return ret;
}

+ (id)mutableAttributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(CTTextAlignment)alignment firstLineIndent:(CGFloat)firstLineIndent hangingIndent:(CGFloat)hangingIndent tabInterval:(CGFloat)tabInterval
{
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    if (string != nil)
        CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)string);
    
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTForegroundColorAttributeName, color.CGColor);
    
    CTFontRef theFont = [font CTFontCreate];
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTFontAttributeName, theFont);
    CFRelease(theFont);
    
    CTTextTabRef tabArray[] = { CTTextTabCreate(kCTTextAlignmentLeft, 0, NULL) };
    CFArrayRef tabStops = CFArrayCreate( kCFAllocatorDefault, (const void**) tabArray, 1, &kCFTypeArrayCallBacks );
    CFRelease(tabArray[0]);
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(firstLineIndent), &firstLineIndent},
        {kCTParagraphStyleSpecifierHeadIndent, sizeof(hangingIndent), &hangingIndent},
        {kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(tabInterval), &tabInterval},
        {kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFAttributedStringGetLength(attrString)), kCTParagraphStyleAttributeName, paragraphStyle);
    CFRelease(paragraphStyle);
    
    CFRelease(tabStops);
    
    NSMutableAttributedString *ret = (NSMutableAttributedString *)CFBridgingRelease(attrString);
    
    return ret;
}

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight
{
   CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFMutableAttributedStringRef) self); 
   CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGFLOAT_MAX, inHeight), NULL);
   CFRelease(framesetter);
   return suggestedSize.width;   
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth
{
   CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFMutableAttributedStringRef) self); 
   CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, CGFLOAT_MAX), NULL);
   CFRelease(framesetter);
   return suggestedSize.height;
}


@end
