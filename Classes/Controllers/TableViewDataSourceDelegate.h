/*
 *  TableViewDataSourceDelegate.h
 *  ZWorkbench
 *
 *  Created by Christopher Garrett on 5/8/08.
 *  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
 *
 */

#import "ARObject.h"

@protocol TableViewDataSourceDelegate

- (void)dataSourceIsReady:(id <UITableViewDataSource>)dataSource;

@end
