//
//  DTTableViewRow.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewRow.h"

@interface DTTableViewRow()
@property (nonatomic, retain) UITableViewCell *cell;
@end


@implementation DTTableViewRow
@synthesize cell, detailViewController;

- (void)dealloc {
    [cell release];
    [detailViewController release];
    
    [super dealloc];
}

- (id)initWithCell:(UITableViewCell *)newCell detailViewController:(UIViewController *)newDetailViewController {
    if (self = [super init]) {
        self.cell = newCell;
        self.detailViewController = newDetailViewController;
    }
    return self;
}

+ (DTTableViewRow *)rowWithCell:(UITableViewCell *)cell detailViewController:(UIViewController *)detailViewController {
    return [[[self alloc] initWithCell:cell detailViewController:detailViewController] autorelease];
}

@end
