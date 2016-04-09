//
//  UIScreen+Zest.h
//  BlueDevils
//
//  Created by Curtis Duhn on 4/1/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

@import Foundation;
@import UIKit;


@interface UIScreen(Zest)

- (CGPoint)center;

@property(readonly) CGFloat bcompat_scale;
@property(readonly) BOOL is2X;

@end
