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

+ (id)viewWithImageNamed: (NSString *) imageName {
   return [[self class] viewWithImage: [UIImage imageNamed: imageName]];
}

+ (UIImageView *)defaultPNGView {
	return  [UIImageView viewWithImage:[UIImage imageNamed:@"Default.png"]];
}

- (IBAction) highlight: (id) src {
   self.highlighted = YES;
}

- (IBAction) unhighlight: (id) src {
   self.highlighted = NO;
}


@end
