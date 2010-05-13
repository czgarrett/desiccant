//
//  UIImageView+Zest.m
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UIImageView+Zest.h"


@implementation UIImageView(Zest)

+ (id)viewWithImage:(UIImage *)theImage {
	return [[(UIImageView *)[self alloc] initWithImage:theImage] autorelease];
}

+ (UIImageView *)defaultPNGView {
	return  [UIImageView viewWithImage:[UIImage imageNamed:@"Default.png"]];
}

@end
