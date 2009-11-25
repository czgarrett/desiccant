//
//  UITabBarItem+Zest.m
//  PortablePTO
//
//  Created by Christopher Garrett on 6/25/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "UITabBarItem+Zest.h"

@implementation UITabBarItem (Zest)

+ (UITabBarItem *) itemNamed: (NSString *)name {
   NSString *imagePath = [NSString stringWithFormat: @"%@_tab_icon.png", [name lowercaseString]];
   UIImage *image = [UIImage imageNamed: imagePath];
   UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle: [name capitalizedString] 
                                                            image: image 
                                                              tag: 0];
   [tabBarItem autorelease];
   return tabBarItem;
}


@end
