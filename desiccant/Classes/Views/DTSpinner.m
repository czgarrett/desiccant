//
//  DTSpinner.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSpinner.h"

static int g_dtSpinnerShowCount = 0;

@implementation DTSpinner

+ (void)show {
	@synchronized ([UIApplication sharedApplication]) {
        if (g_dtSpinnerShowCount == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        g_dtSpinnerShowCount++;
	}
}

+ (void)hide {
	@synchronized ([UIApplication sharedApplication]) {
        g_dtSpinnerShowCount--;
        if (g_dtSpinnerShowCount <= 0) {
            g_dtSpinnerShowCount = 0;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	}
}

@end
