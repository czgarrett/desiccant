//
//  DCManagedObjectListController.m
//  WordTower
//
//  Created by Christopher Garrett on 8/30/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#ifdef __IPHONE_3_0
#import "DTCoreDataTableViewController.h"


@implementation DTCoreDataTableViewController

@synthesize managedObjectContext, fetchedResultsController, entityName, sortAttribute, ascending;

#pragma mark Editing

#pragma mark UITableViewDelegate methods

#pragma mark View Delegate methods

- (void)viewDidLoad {
	[super viewDidLoad];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}  
}

//- (void) afterViewDidLoad:(UITableView *)theTableView {
//   [super afterViewDidLoad:theTableView];
//   NSError *error = nil;
//	if (![[self fetchedResultsController] performFetch:&error]) {
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		abort();
//   }  
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   // Support all orientations except upside down
   return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   NSInteger count = [[fetchedResultsController sections] count];
   
	if (count == 0) {
		count = 1;
	}
	
   return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSInteger numberOfRows = 0;
	
   if ([[fetchedResultsController sections] count] > 0) {
      id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
      numberOfRows = [sectionInfo numberOfObjects];
   }
   
   return numberOfRows;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   if (editingStyle == UITableViewCellEditingStyleDelete) {
      // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
      NSManagedObject *mob = [fetchedResultsController objectAtIndexPath:indexPath];
		[context deleteObject: mob];
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}

#pragma mark Table Cell Stuff

- (void)configureCell:(UITableViewCell *)myCell atIndexPath:(NSIndexPath *)indexPath {
   myCell.textLabel.text = @"Override configureCell:";
}

- (UITableViewCellStyle) defaultCellStyle {
   return UITableViewCellStyleDefault;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *cellIdentifier = [NSString stringWithFormat: @"%@CellIdentifier", self.entityName];
   
   UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   if (theCell == nil) {
      theCell = [[[UITableViewCell alloc] initWithStyle: [self defaultCellStyle] reuseIdentifier: cellIdentifier] autorelease];
		theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   }
   [self configureCell: cell atIndexPath: indexPath];
   
   return theCell;
}


#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
   // Set up the fetched results controller if needed.
   if (fetchedResultsController == nil) {
      // Create the fetch request for the entity.
      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
      // Edit the entity name as appropriate.
      NSEntityDescription *entity = [NSEntityDescription entityForName: self.entityName inManagedObjectContext:managedObjectContext];
      [fetchRequest setEntity:entity];
      
      // Edit the sort key as appropriate.
      NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: self.sortAttribute ascending: self.ascending];
      NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
      
      [fetchRequest setSortDescriptors:sortDescriptors];
      
      // Edit the section name key path and cache name if appropriate.
      // nil for section name key path means "no sections".
      NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                  managedObjectContext:managedObjectContext 
                                                                                                    sectionNameKeyPath:nil 
                                                                                                             cacheName: [NSString stringWithFormat: @"%@ Cache", self.entityName]];
      aFetchedResultsController.delegate = self;
      self.fetchedResultsController = aFetchedResultsController;
      
      [aFetchedResultsController release];
      [fetchRequest release];
      [sortDescriptor release];
      [sortDescriptors release];
   }
	
	return fetchedResultsController;
}    


#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell: [tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}


#pragma mark LifeCycle

- (id) initWithEntityName: (NSString *) myEntityName sortAttribute: (NSString *) mySortAttribute {
   if (self = [super initWithStyle: UITableViewStylePlain]) {
      self.entityName = myEntityName;
      self.sortAttribute = mySortAttribute;
      self.ascending = YES;
   }
   return self;
}

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
   [super dealloc];
}


@end
#endif