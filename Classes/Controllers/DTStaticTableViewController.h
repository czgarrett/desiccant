//
//  DTStaticTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCustomTableViewController.h"

@interface DTStaticTableViewController : DTSetDataBasedTableViewController {
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

// Call this before one or more insertRow* calls if you want to inject a new section of rows.
- (void)insertSectionAtIndex:(NSUInteger)index;

// Call this before one or more insertRow* calls if you want to inject a new section of rows.
// The section header will have the specified title.
- (void)insertSectionAtIndex:(NSUInteger)index withTitle:(NSString *)title;

// Removes the section with the specfied index, and all associated rows
- (void)removeSectionWithIndex:(NSUInteger)index;

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

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector atIndexPath:(NSIndexPath *)indexPath;

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

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithNibNamed:(NSString *)nibName atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController atIndexPath:(NSIndexPath *)indexPath;

// Like its add... variant, except inserts the row at the given index path.
// Doesn't update the view.  Use reloadTable or insertRowsAtIndexPaths on the tableView after this.
- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector atIndexPath:(NSIndexPath *)indexPath;

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

// Removes the specfied row.
- (void)removeRowWithIndexPath:(NSIndexPath *)indexPath;

// Returns a cell from the specified nib.  Useful for getting a cell, customizing it, 
// then passing it to addRowWithDedicatedCell:...
- (id)cellWithNibNamed:(NSString *)nibName;

@end
