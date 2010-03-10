//
//  DTStaticTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@interface DTStaticTableViewController : DTTableViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionTitles;
	NSMutableDictionary *prototypeCells;
}

@property (nonatomic, retain, readonly) NSMutableArray *sections;
@property (nonatomic, retain, readonly) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableDictionary *prototypeCells;

// Call this before one or more addRow* calls to mark the start of a table section.
- (void)startSection;

// Call this before one or more addRow* calls to mark the start of a table section.  The section header will have the specified
// title.
- (void)startSectionWithTitle:(NSString *)title;

// Adds a row with the specified dedicated cell.  theCell must NOT have a reuse identifier.
- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell;

// Adds a row with the specified dedicated cell, and populates that cell with rowData.  theCell must NOT have a reuse identifier.
- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData;

// Adds a row with the specified dedicated cell, and populates that cell with rowData.  
// Will push detailViewController when the row is selected.  theCell must NOT have a reuse identifier.
- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController;

// Adds a row with the specified dedicated cell, and populates that cell with rowData.  
// Will inject data into detailViewController using dataInjector and then push it onto the nav stack when row is selected.
// theCell must NOT have a reuse identifier.
- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector;

// Adds a row with that will be constructed from the specified nib.  If the cell returned by the nib has a reuse identifier, 
// reusable cells will be dequed from the tableView or constructed from the nib when requested.  If the cell has no reuse 
// identifier, a dedicated cell will be constructed immediately and returned directly whenever this row is requested.
- (void)addRowWithNibNamed:(NSString *)nibName;

// Adds a row with that will be constructed from the specified nib.  If the cell returned by the nib has a reuse identifier, 
// reusable cells will be dequed from the tableView or constructed from the nib and populated via setData: when requested.  
// If the cell has no reuse identifier, a dedicated cell will be constructed and populated via setData immediately, and 
// then returned directly whenever this row is requested.
- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData;

// Adds a row with that will be constructed from the specified nib.  If the cell returned by the nib has a reuse identifier, 
// reusable cells will be dequed from the tableView or constructed from the nib and populated via setData: when requested.  
// If the cell has no reuse identifier, a dedicated cell will be constructed and populated via setData immediately, and 
// then returned directly whenever this row is requested.  Will push detailViewController when the row is selected.
- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController;

// Adds a row with that will be constructed from the specified nib.  If the cell returned by the nib has a reuse identifier, 
// reusable cells will be dequed from the tableView or constructed from the nib and populated via setData: when requested.  
// If the cell has no reuse identifier, a dedicated cell will be constructed and populated via setData immediately, and 
// then returned directly whenever this row is requested.  Will inject data into detailViewController using dataInjector 
// and then push it onto the nav stack when the row is selected. 
- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector;

// Adds multiple rows that will be constructed from the specified nib, one for each element in rowDataArray.  If the cell 
// returned by the nib has a reuse identifier, reusable cells will be dequed from the tableView or constructed from the nib 
// and populated via setData: when these rows are requested.  If the cell has no reuse identifier, dedicated cells will be 
// constructed and populated via setData immediately, and then returned directly whenever these rows are requested.
- (void)addRowsWithNibNamed:(NSString *)nibName dataArray:(NSArray *)rowDataArray;

// Adds multiple rows that will be constructed from the specified nib, one for each element in rowDataArray.  If the cell 
// returned by the nib has a reuse identifier, reusable cells will be dequed from the tableView or constructed from the nib
// and populated via setData: when these rows are requested.  If the cell has no reuse identifier, dedicated cells will be
// constructed and populated via setData immediately, and then returned directly whenever these rows are requested.  
// Will inject data into detailViewController using dataInjector and then push it onto the nav stack when one of these rows
// is selected.
- (void)addRowsWithNibNamed:(NSString *)nibName dataArray:(NSArray *)rowDataArray detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector;


@end
