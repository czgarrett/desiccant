//
//  ACCustomTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCustomTableViewController.h"

@interface DTCustomTableViewController()
+ (NSInteger)nextIdentifierNumber;
@end

@implementation DTCustomTableViewController
@synthesize cellNibName, cellIdentifier;

- (void)dealloc {
    [cellNibName release];
    [cellIdentifier release];
    
    [super dealloc];
}

- (void)beforeTableViewDidLoad:(UITableView *)theTableView {
    self.cellIdentifier = [NSString stringWithFormat:@"cell_type_%d", [DTCustomTableViewController nextIdentifierNumber]];
	[super beforeTableViewDidLoad:theTableView];
}

+ (NSInteger)nextIdentifierNumber {
    static NSInteger number = 0;
    return ++number;
}

// Subclasses can override this to return a custom subclass of DTCustomTableViewCell with retain count 0 (autoreleased)
- (DTCustomTableViewCell *)constructCell {
    return [[[DTCustomTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
}

@end
