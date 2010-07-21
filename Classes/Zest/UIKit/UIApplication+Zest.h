//
//  UIApplication+Zest.h
//  NoteToSelf
//
//  Created by Curtis Duhn on 7/21/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIApplication(Zest)
- (void)bcompat_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;
@end
