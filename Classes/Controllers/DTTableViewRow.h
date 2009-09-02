//
//  DTTableViewRow.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DTTableViewRow : NSObject {
    UITableViewCell *cell;
    UIViewController *detailViewController;
}

@property (nonatomic, retain, readonly) UITableViewCell *cell;
@property (nonatomic, retain) UIViewController *detailViewController;

- (id)initWithCell:(UITableViewCell *)newCell detailViewController:(UIViewController *)newDetailViewController;
+ (DTTableViewRow *)rowWithCell:(UITableViewCell *)cell detailViewController:(UIViewController *)detailViewController;

@end
