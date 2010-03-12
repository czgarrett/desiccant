//
//  DTCoreDataListSelectionController.m
//  ProLog
//
//  Created by Christopher Garrett on 9/22/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTCoreDataListSelectionViewController.h"
#import "Zest.h"

@implementation DTCoreDataListSelectionViewController

@synthesize selectedObject, delegate, tag, editable, currentSearchText, currentSearchScope;

#pragma mark Button support

- (IBAction) editButtonPressed: (id) button {
   [self setEditing: YES animated: YES];
}

- (IBAction) saveButtonPressed: (id) button {
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
   if (editing) {
      [self.navigationItem setRightBarButtonItem: saveButton animated: YES];      
   } else {
      [self.navigationItem setRightBarButtonItem: editButton animated: YES];            
   }
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
   UITableViewCell *theCell = nil;

   NSArray *sections = [self.fetchedResultsController sections];
   NSInteger rowCount = 0;
   if ([sections count] > 0) {
      id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex: indexPath.section];
      rowCount =  [sectionInfo numberOfObjects];
   }
		
      if (indexPath.row < rowCount) {
         theCell = [super tableView: tableView cellForRowAtIndexPath: indexPath];
      } else {
         // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddCellIdentifier = @"AddItemCell";
			
			theCell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
			if (theCell == nil) {
				theCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
				theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
         theCell.textLabel.text = [NSString stringWithFormat: @"Add %@", self.entityName];
      }
   return theCell;
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

- (void) updateFooterView {
   UIView *newFooterView = [self footerView];
   if ([[self.fetchedResultsController fetchedObjects] count] == self.fetchLimit) {
      newFooterView = tooManyResultsFooterView;
   }
   [[self tableView] setTableFooterView: newFooterView];
}

#pragma mark Filtering

- (void) filter {
   NSAutoreleasePool	 *pool = [[NSAutoreleasePool alloc] init];
   if (needsFiltering && !currentlyFiltering) {
      [self.activityIndicator startAnimating];
      currentlyFiltering = YES;
      NSLog(@"Filtering with text: %@", self.currentSearchText);
      needsFiltering = NO;
      NSPredicate *predicate = [self predicateForSearchText: self.currentSearchText scope: self.currentSearchScope];
      if (predicate) {
         [self.fetchedResultsController.fetchRequest setPredicate: predicate];      
      }
      NSError *error;
      if (![self.fetchedResultsController performFetch: &error]) {
         [self handleUnexpectedError: error];
      }
      [self performSelectorOnMainThread: @selector(updateFooterView) withObject: nil waitUntilDone: YES];      
      if (!needsFiltering) { // Filter text changed in main thread
         [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread: @selector(reloadData) withObject: nil waitUntilDone: YES];      
         [self.tableView performSelectorOnMainThread: @selector(reloadData) withObject: nil waitUntilDone: YES];      
      }
      [self.activityIndicator stopAnimating];
      if (needsFiltering) {
         [self filter];
      }
      currentlyFiltering = NO;
   }
   [pool release];
}

- (void) performFetch  {
   [self filterContentForSearchText: nil scope: 0];
}


- (void) filterContentForSearchText: (NSString *) searchText scope: (NSInteger) scopeIndex {
   needsFiltering = YES;
   self.currentSearchText = searchText;
   self.currentSearchScope = scopeIndex;
   NSLog(@"Filter content for search text: %@", searchText);
   [self performSelectorInBackground: @selector(filter) withObject: nil];
   //[self filter];
}

- (NSPredicate *) predicateForSearchText: (NSString *)searchText scope: (NSInteger) scopeIndex {
   return nil;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   [self filterContentForSearchText:searchString scope: self.searchDisplayController.searchBar.selectedScopeButtonIndex];
   return NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
   [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope: searchOption];
   return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
   [self.view bringSubviewToFront: self.activityIndicator];
   //[self.activityIndicator removeFromSuperview];
   //[tableView addSubview: self.activityIndicator];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
   //[self.activityIndicator removeFromSuperview];
   //[self.view addSubview: self.activityIndicator];
}

#pragma mark Lifecycle

- (void) viewDidAppear:(BOOL)animated {
   [self updateFooterView];
   [super viewDidAppear: animated];
}

- (void)viewDidLoad {
   [super viewDidLoad];
   if (self.editable) {
      self.tableView.allowsSelectionDuringEditing = YES;
   } else {
      [self.navigationItem setRightBarButtonItem: nil animated: NO];
   }
   
}


- (void)dealloc {
   self.selectedObject = nil;
   self.currentSearchText = nil;
   [super dealloc];
}

@end