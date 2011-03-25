//
//  UIBarButtonItem+Zest.m
//
//  Created by Curtis Duhn on 12/8/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "UIBarButtonItem+Zest.h"


@implementation UIBarButtonItem(Zest)

//- (void)dealloc {
//    [super dealloc];
//}

+ itemWithTitle:(NSString *)title {
	UIBarButtonItem *item = [[[UIBarButtonItem alloc] init] autorelease];
	item.title = title;
	return item;
}

@end


@interface FixCategoryBugUIBarButtonItem : NSObject {}
@end
@implementation FixCategoryBugUIBarButtonItem
@end