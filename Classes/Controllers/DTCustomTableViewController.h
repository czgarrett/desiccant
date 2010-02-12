//
//  ACCustomTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTTableViewController.h"

@interface DTCustomTableViewController : DTTableViewController {
    NSString *cellNibName;    
    NSString *cellIdentifier;    
}

// Subclasses may set this property in viewDidLoad.  It is used to identify a .xib to use for the cell view.
@property (nonatomic, retain) NSString *cellNibName;
@property (nonatomic, retain) NSString *cellIdentifier;

// Returns the next unique identifier number, which can be used to construct unique reuseIdentifiers
+ (NSInteger)nextIdentifierNumber;

// Subclasses can override this to return a custom subclass of DTCustomTableViewCell.  This is only called if
// cellNibName is not set
- (DTCustomTableViewCell *)constructCell;

@end
