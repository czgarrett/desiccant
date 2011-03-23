//
//  DTLinkButton.m
//  RedRover
//
//  Created by Christopher Garrett on 12/10/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import "DTUnderlinedLabel.h"
#import <CoreText/CoreText.h>
#import "NSDictionary+Zest.h"
#import "CBucks.h"

@implementation DTUnderlinedLabel


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) awakeFromNib {
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   CFStringRef string = (CFStringRef) self.text; 
   if (string) {
      CGFontRef cgFont = CGFontCreateWithFontName((CFStringRef) self.font.fontName);
      CTFontRef ctFont = CTFontCreateWithGraphicsFont(cgFont, self.font.pointSize, NULL, NULL);
      CGContextRef context = UIGraphicsGetCurrentContext();
      // Initialize string, font, and context
      
      CFDictionaryRef attributes = (CFDictionaryRef) $D((NSString *)kCTFontAttributeName, ctFont, 
                                                        (NSString *)kCTForegroundColorAttributeName, self.textColor.CGColor, 
                                                        (NSString *)kCTUnderlineStyleAttributeName, [NSNumber numberWithInt: kCTUnderlineStyleSingle],
                                                        (NSString *)kCTUnderlineColorAttributeName, self.textColor.CGColor);
      
      CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
      
      CTLineRef line = CTLineCreateWithAttributedString(attrString);
      
      CGContextTranslateCTM(context, 0.0f, rect.size.height);
      CGContextScaleCTM(context, 1.0f, -1.0f);
      
      // Set text position and draw the line into the graphics context
      CGContextSetTextPosition(context, 0.0, 10.0);
      CTLineDraw(line, context);
      
      CFRelease(line);
      CFRelease(ctFont);
      CFRelease(cgFont);
      CFRelease(attrString);
   }
}

- (void)dealloc {
    [super dealloc];
}

@end
