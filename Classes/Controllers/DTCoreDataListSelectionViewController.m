//
//  DTCoreDataListSelectionController.m
//  ProLog
//
//  Created by Christopher Garrett on 9/22/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTCoreDataListSelectionViewController.h"


@implementation DTCoreDataListSelectionViewController

@synthesize selectedObject, delegate, searchBar;

#pragma mark TableView delegate methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (self.searchDisplayController.active) {
      [self.searchDisplayController setActive: NO animated: YES];
      return nil;
   }
   return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   self.selectedObject = [self.fetchedResultsController objectAtIndexPath: indexPath];
   [self.delegate selectionViewController: self didSelectObject: self.selectedObject];
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

- (void)viewDidLoad {
   [super viewDidLoad];
   unless (searchBar.hidden) {
      [[self tableView] setTableHeaderView: searchBar];
   }
}


- (void)dealloc {
   self.selectedObject = nil;
   [super dealloc];
}

@end