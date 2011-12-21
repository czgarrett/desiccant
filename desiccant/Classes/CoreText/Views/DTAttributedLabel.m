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

@synthesize attributedString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setup];
    }
    return self;
}

- (void) awakeFromNib {
   [self setup];
}

- (void) setup {
   self.clipsToBounds = NO;
   
}

- (void) dealloc {
   CFRelease(attributedString);
   [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   if (!attributedString) return;
   // Initialize a graphics context and set the text matrix to a known value.
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
   
   CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(self.bounds.size.width, CGFLOAT_MAX), NULL);
   
   CGContextSaveGState(context);

   // Create the frame and draw it into the graphics context
   // Initialize a rectangular path.
   CGMutablePathRef path = CGPathCreateMutable();
   CGPathAddRect(path, NULL, CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, suggestedSize.height));
   CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                               CFRangeMake(0, CFAttributedStringGetLength((CFAttributedStringRef)attributedString)), 
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
