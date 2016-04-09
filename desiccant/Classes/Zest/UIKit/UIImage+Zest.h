//
//  UIImage+Zest.h
//  WordTower
//
//  Created by Christopher Garrett on 7/7/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void(^ImageBlock)(UIImage *);

typedef void(^ImageContextBlock)(CGContextRef ctx);

@interface UIImage (Zest) 

+ (UIImage *)newImageFromResource:(NSString *)resource ofType:(NSString *)type;
+ (void) loadImageFromURL: (NSURL *) url completion: (ImageBlock) block;

+ (UIImage *) drawImageWithSize: (CGSize) size drawingBlock: (ImageContextBlock) drawingBlock;
+ (UIImage *) drawImageWithSize: (CGSize) size capInsets: (UIEdgeInsets) capInsets drawingBlock: (ImageContextBlock) drawingBlock;

- (UIImage *) imageScaledAndCroppedToMaxSize: (CGSize) maxSize;
- (UIImage *) imageScaledToMaxWidth: (CGFloat) width;
- (UIImage *) imageCroppedToRect: (CGRect) rect;


@end
