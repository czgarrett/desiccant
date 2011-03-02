//
//  UIImageView+Zest.h
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(Zest)
   
+ (id)viewWithImage:(UIImage *)theImage;
+ (id)viewWithImageNamed:(NSString *)imageName;
+ (UIImageView *)defaultPNGView;


// Useful when UIImageView is used as a subview of a UIButton.
- (IBAction) highlight: (id) src;
- (IBAction) unhighlight: (id) src;

@end
