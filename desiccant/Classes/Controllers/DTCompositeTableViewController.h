//
//  DTCompositeTableViewController.h
//
//  Created by Curtis Duhn on 11/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCompositeTableViewControllerMapping.h"

@interface DTCompositeTableViewController : DTTableViewController {
	NSMutableArray *controllerMappings;
}

- (void)addControllerMapping:(DTCompositeTableViewControllerMapping *)mapping;

@end
