//
//  DTCoreDataMultiSelectionViewController.m
//  ProLog
//
//  Created by Christopher Garrett on 10/8/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTCoreDataMultiSelectionViewController.h"


@implementation DTCoreDataMultiSelectionViewController

@synthesize selectedObjects, delegate;

#pragma mark Button support

- (IBAction) nextButtonPressed: (id) button {
   [self.delegate multiSelectionViewController: self didSelectObjects: self.selectedObjects];
}

- (IBAction) cancelButtonPressed: (id) button {
   [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) selectAllButtonPressed: (id) button {
   [self.selectedObjects addObjectsFromArray: [self.fetchedResultsController fetchedObjects]];
   [[[self searchDisplayController] searchResultsTableView] reloadData];
   [[self tableView] reloadData];
}

- (IBAction) selectNoneButtonPressed: (id) button {
   [self.selectedObjects removeAllObjects];
   [[[self searchDisplayController] searchResultsTableView] reloadData];
   [[self tableView] reloadData];
}


#pragma mark TableView delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSManagedObject *selected = [self.fetchedResultsController objectAtIndexPath: indexPath];
   if ([self.selectedObjects containsObject: selected]) {
      [self.selectedObjects removeObject: selected];
   } else {
      [self.selectedObjects addObject: selected];
   }
   [tableView deselectRowAtIndexPath: indexPath animated: NO];
   [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationNone];
}

- (void) tableView:(UITableView *)tableView didDeselectSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //[self.selectedObjects removeObject: [self.fetchedResultsController objectAtIndexPath: indexPath]];
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
   NSArray *results = [self.fetchedResultsController fetchedObjects];
   [self.selectedObjects intersectSet: [NSSet setWithArray: results]];
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
   if (self.selectedObjects == nil) {
      self.selectedObjects = [NSMutableSet setWithCapacity: 10];      
   }
   [super viewDidLoad];
   [self.navigationItem setRightBarButtonItem: nextButton animated: NO];
   [self.navigationItem setLeftBarButtonItem: cancelButton animated: NO];
}


- (void)dealloc {
   self.selectedObjects = nil;
   [super dealloc];
}

@end

