//
//  UIImage+Zest.m
//  WordTower
//
//  Created by Christopher Garrett on 7/7/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import "UIImage+Zest.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage(Zest)

+ (UIImage *)newImageFromResource:(NSString *)resource ofType:(NSString *)type {
	UIImage *image = nil;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	UIScreen *mainScreen = [UIScreen mainScreen];
	if ([mainScreen respondsToSelector:@selector(scale)] && [mainScreen scale] == 2.0) {
		NSString *resourceHighRes = [NSString stringWithFormat:@"%@@2x", resource];
		NSString *path = [[NSBundle mainBundle] pathForResource:resourceHighRes ofType:type];
		UIImage *tempImage = [[UIImage alloc] initWithContentsOfFile:path];
		if (tempImage && [tempImage respondsToSelector:@selector(initWithCGImage:scale:orientation:)]) {
			image = [[UIImage alloc] initWithCGImage:tempImage.CGImage scale:2.0 orientation:tempImage.imageOrientation];
		}
		[tempImage release];
	}
#endif
	if (!image)  {
		NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
		image = [[UIImage alloc] initWithContentsOfFile:path];
	}
	return image;
}

+ (void) loadImageFromURL: (NSURL *) url completion: (ImageBlock) imageBlock {
   dispatch_queue_t image_queue = dispatch_queue_create(NULL, NULL);
   dispatch_async(image_queue, ^{
      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: url]];
      dispatch_async(dispatch_get_main_queue(), ^{
         imageBlock(image);   
      });
   });
   dispatch_release(image_queue);
}

+ (id)imageByCapturingView:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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

- (UIImage *) imageCroppedToRect: (CGRect) rect {
   UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
   [self drawInRect: CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
   UIGraphicsEndImageContext();
   return newImage;
}

- (UIImage *) imageScaledToMaxWidth: (CGFloat) width {
   float factor = self.size.width / width;
   
   // Divide the size by the greater of the vertical or horizontal shrinkage factor
   float newWidth = self.size.width / factor;
   float newHeight = self.size.height / factor;
   
   
   UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
   [self drawInRect: CGRectMake(0.0, 0.0, newWidth, newHeight)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
   UIGraphicsEndImageContext();
   return newImage;
}



@end


@interface FixCategoryBugUIImage : NSObject {}
@end
@implementation FixCategoryBugUIImage
@end
