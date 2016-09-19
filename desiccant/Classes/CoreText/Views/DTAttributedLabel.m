//
//  DTAttributedLabel.m
//  blush
//
//  Created by Garrett Christopher on 12/21/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTAttributedLabel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface DTAttributedLabel() {
@private
}

- (void) setup;

@end

@implementation DTAttributedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setup];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
   [self setup];
}

- (void) setup {
   self.clipsToBounds = NO;
}

- (void) setAttributedString:(NSMutableAttributedString *)attributedString {
   _attributedString = attributedString;
   
   [self invalidateIntrinsicContentSize];
   [self setNeedsDisplay];
}

- (CGSize) intrinsicContentSize {
   CGSize size = CGSizeZero;
   if (_attributedString) {
      CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef) _attributedString);
      if (framesetter != NULL) {
         size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX), NULL);
         CFRelease(framesetter);
      }
   }
   return size;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   if (!_attributedString) return;
   
   // Initialize a graphics context and set the text matrix to a known value.
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedString);
   
   CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX), NULL);
   suggestedSize.height += 20.0;
   
   CGContextSaveGState(context);

   // Create the frame and draw it into the graphics context
   // Initialize a rectangular path.
   CGMutablePathRef path = CGPathCreateMutable();
   CGPathAddRect(path, NULL, CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, suggestedSize.height));
   CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                               CFRangeMake(0, 0), 
                                               path, 
                                               NULL);
   CGPathRelease(path);
   CFRelease(framesetter);

   CGContextSetTextMatrix(context, CGAffineTransformIdentity);
   CGContextTranslateCTM(context, 0.0, suggestedSize.height);
   CGContextScaleCTM(context, 1.0, -1.0); 
   CTFrameDraw(frame, context);

   CGContextRestoreGState(context);
   CFRelease(frame);
}

@end
