//
//  UIImage+Zest.m
//  WordTower
//
//  Created by Christopher Garrett on 7/7/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import "UIImage+Zest.h"


@implementation UIImage(Zest)

+ (UIImage *)newImageFromResource:(NSString *)resource ofType:(NSString *)type {
   UIImage *image = nil;
   UIScreen *mainScreen = [UIScreen mainScreen];
   if ([mainScreen respondsToSelector:@selector(scale)] && [mainScreen scale] == 2.0)         {
      NSString *resourceHighRes = [NSString stringWithFormat:@"%@@2x", resource];
      NSString *path = [[NSBundle mainBundle] pathForResource:resourceHighRes ofType:type];
      UIImage *tempImage = [[UIImage alloc] initWithContentsOfFile:path];
      if (tempImage && [tempImage respondsToSelector:@selector(initWithCGImage:scale:orientation:)]) {
         image = [[UIImage alloc] initWithCGImage:tempImage.CGImage scale:2.0 orientation:tempImage.imageOrientation];
      }
      [tempImage release];
   }
   if (!image)  {
      NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
      image = [[UIImage alloc] initWithContentsOfFile:path];
   }
   return image;
}

- (UIImage *) imageScaledAndCroppedToMaxSize: (CGSize) maxSize {
   float hfactor = self.size.width / maxSize.width;
   float vfactor = self.size.height / maxSize.height;
   
   float factor = MIN(hfactor, vfactor);
   
   // Divide the size by the greater of the vertical or horizontal shrinkage factor
   float newWidth = self.size.width / factor;
   float newHeight = self.size.height / factor;
   
   // Then figure out if you need to offset it to center vertically or horizontally
   float leftOffset = (maxSize.width - newWidth) / 2;
   float topOffset = (maxSize.height - newHeight) / 2;
   
   UIGraphicsBeginImageContext(maxSize);
   [self drawInRect: CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
   UIGraphicsEndImageContext();
   return newImage;
}


@end
