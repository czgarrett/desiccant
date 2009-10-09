//
//  DTCoreDataListSelectionController.m
//  ProLog
//
//  Created by Christopher Garrett on 9/22/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTCoreDataListSelectionViewController.h"


@implementation DTCoreDataListSelectionViewController

@synthesize selectedObject, delegate, tag, editable;

#pragma mark Button support

- (IBAction) editButtonPressed: (id) button {
   [self.navigationItem setRightBarButtonItem: saveButton animated: YES];
   [self setEditing: YES animated: YES];
}

- (IBAction) saveButtonPressed: (id) button {
   [self.navigationItem setRightBarButtonItem: editButton animated: YES];   
   [self setEditing: NO animated: YES];
}

#pragma mark Editing support


#pragma mark TableView delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   self.selectedObject = [self.fetchedResultsController objectAtIndexPath: indexPath];
   [self.delegate selectionViewController: self didSelectObject: self.selectedObject];
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
   [super setEditing:editing animated:animated];
   [self.navigationItem setHidesBackButton:editing animated:animated];
   [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSInteger existingRows = [super tableView: tableView numberOfRowsInSection: section];
   if (self.editing) {
      return existingRows + 1;
   } else {
      return existingRows;
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = nil;

   NSArray *sections = [self.fetchedResultsController sections];
   NSInteger rowCount = 0;
   if ([sections count] > 0) {
      id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex: indexPath.section];
      rowCount =  [sectionInfo numberOfObjects];
   }
		
      if (indexPath.row < rowCount) {
         cell = [super tableView: tableView cellForRowAtIndexPath: indexPath];
      } else {
         // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddCellIdentifier = @"AddItemCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
         cell.textLabel.text = [NSString stringWithFormat: @"Add %@", self.entityName];
      }
   return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
   if (indexPath.row == [self tableView: tableView numberOfRowsInSection: indexPath.section] - 1) {
      // It's the insertion row
      style = UITableViewCellEditingStyleInsert;
   }
   else {
      style = UITableViewCellEditingStyleDelete;
   }
   return style;
}


#pragma mark Filtering

- (void) filterContentForSearchText: (NSString *) searchText scope: (NSInteger) scopeIndex {
   NSPredicate *predicate = [self predicateForSearchText: searchText scope: scopeIndex];
   if (predicate) {
      [self.fetchedResultsController.fetchRequest setPredicate: predicate];      
   }
   NSError *error;
   if (![self.fetchedResultsController performFetch: &error]) {
      NSLog(@"Fetch error: %@", error);
   }
   [[self tableView] reloadData];      
}

- (NSPredicate *) predicateForSearchText: (NSString *)searchText scope: (NSInteger) scopeIndex {
   return nil;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   [self filterContentForSearchText:searchString scope: self.searchDisplayController.searchBar.selectedScopeButtonIndex];
   return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
   [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope: searchOption];
   return YES;
}


#pragma mark Lifecycle

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
}

- (void)viewDidLoad {
   [super viewDidLoad];
   if (self.editable) {
      self.tableView.allowsSelectionDuringEditing = YES;
      [self.navigationItem setRightBarButtonItem: editButton animated: NO];
   } else {
      [self.navigationItem setRightBarButtonItem: nil animated: NO];
   }
   
}


- (void)dealloc {
   self.selectedObject = nil;
   [super dealloc];
}

@end