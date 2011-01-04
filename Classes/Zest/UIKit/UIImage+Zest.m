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

@end
