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
   NSUInteger headerRows;
}

// Subclasses may set this property in viewDidLoad.  It is used to identify a .xib to use for the cell view.
@property (nonatomic, retain) NSString *cellNibName;
@property (nonatomic, retain) NSString *cellIdentifier;

#pragma mark Cell methods
// Returns the next unique identifier number, which can be used to construct unique reuseIdentifiers
+ (NSInteger)nextIdentifierNumber;

// Subclasses can override this to return a custom subclass of DTCustomTableViewCell.  This is only called if
// cellNibName is not set
- (DTCustomTableViewCell *)constructCell;
// This is called after the cell is constructed or retrieved using its identifier
- (void) configureCell: (DTCustomTableViewCell *) unconfiguredCell atIndexPath: (NSIndexPath *) indexPath;

// Subclasses can implement this to change the look & feel of any cell.  This is only called if cellNibName is not set. 
- (void)customizeCell;

#pragma mark Header support
@property (nonatomic) NSUInteger headerRows;
// Subclasses must implement this to return a header cell if headerRows > 0
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to override the default header row height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderRowAtIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to override the default data cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForDataRowAtIndexPath:(NSIndexPath *)indexPath;
// Subclasses can implement this to display an error when the query fails.  Does nothing by default.
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath;
- (BOOL)hasHeaders;
- (NSInteger)adjustSectionForHeaders:(NSInteger)section;
- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath;


@end
