//
//  UIImage+Zest.h
//  WordTower
//
//  Created by Christopher Garrett on 7/7/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageBlock)(UIImage *);

@interface UIImage (Zest) 

+ (UIImage *)newImageFromResource:(NSString *)resource ofType:(NSString *)type;
+ (void) loadImageFromURL: (NSURL *) url completion: (ImageBlock) block;

- (UIImage *) imageScaledAndCroppedToMaxSize: (CGSize) maxSize;
- (UIImage *) imageScaledToMaxWidth: (CGFloat) width;
- (UIImage *) imageCroppedToRect: (CGRect) rect;

- (void) drawInRect: (CGRect) rect clippedToRect: (CGRect) clipRect;

@end
