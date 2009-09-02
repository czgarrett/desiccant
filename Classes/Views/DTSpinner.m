//
//  DTSpinner.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSpinner.h"


@implementation DTSpinner

+ (void)show {
	@synchronized ([UIApplication sharedApplication]) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible++;
	}
}

+ (void)hide {
	@synchronized ([UIApplication sharedApplication]) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible--;
	}
}

@end
