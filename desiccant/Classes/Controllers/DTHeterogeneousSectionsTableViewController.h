//
//  DTHeterogeneousTableViewController.h
//  ProLog
//
//  Created by Christopher Garrett on 9/21/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@class DTCustomTableViewCell;

@interface DTHeterogeneousSectionsTableViewController : DTTableViewController {
   NSArray *sectionNames;
   NSArray *sectionHeights;
   NSArray *cellNibNames;
   NSMutableArray *cellIdentifiers;
}

@property (nonatomic, retain) NSArray *sectionNames;
@property (nonatomic, retain) NSArray *sectionHeights;
@property (nonatomic, retain) NSArray *cellNibNames;
@property (nonatomic, retain) NSMutableArray *cellIdentifiers;

- (NSString *) cellNibNameForIndexPath: (NSIndexPath *) indexPath;
- (NSString *) cellIdentifierForIndexPath: (NSIndexPath *) indexPath;
- (void) setCellIdentifier: (NSString *) identifier forIndexPath: (NSIndexPath *) indexPath;
- (DTCustomTableViewCell *)constructCellForIndexPath: (NSIndexPath *)indexPath;


@end
