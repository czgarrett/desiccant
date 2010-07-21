//
//  UIApplication+Zest.m
//  NoteToSelf
//
//  Created by Curtis Duhn on 7/21/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "UIApplication+Zest.h"
#import "Zest.h"

@implementation UIApplication(Zest)

- (void)bcompat_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
	if (DTOSVersion >= 3.2) {
		[self setStatusBarHidden:hidden withAnimation:animation]; 
	}
	else {
		BOOL animated = (BOOL)animation;
		[self performSelector:@selector(setStatusBarHidden:animated:) withReturnValueAndArguments:nil, &hidden, &animated, nil];
	}
}

@end
