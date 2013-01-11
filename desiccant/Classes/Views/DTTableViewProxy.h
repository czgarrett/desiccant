//
//  DTTableViewProxy.h
//
//  Created by Curtis Duhn on 11/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTCompositeTableViewControllerMapping;

@interface DTTableViewProxy : UITableView {
	UITableView *containerTableView;
	DTCompositeTableViewControllerMapping *mapping;
}

@property (nonatomic, retain) UITableView *containerTableView;
@property (nonatomic, retain) DTCompositeTableViewControllerMapping *mapping;

- (id)initWithContainerView:(UITableView *)theContainer mapping:(DTCompositeTableViewControllerMapping *)theMapping;
+ (id)proxyWithContainerView:(UITableView *)theContainer mapping:(DTCompositeTableViewControllerMapping *)theMapping;

@end
