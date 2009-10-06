//
//  ACDictionaryTableController.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/6/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ACDictionaryTableController.h"
#import "EditableCell.h"

@implementation ACDictionaryTableController

@synthesize items, tableView;

- (id) initWithDictionary: (NSMutableDictionary *) myItems delegate: (id <ACDictionaryTableControllerDelegate>) myDelegate {
   delegate = myDelegate;
   if (self = [self initWithStyle: UITableViewStyleGrouped]) {
      self.items = [NSMutableDictionary dictionaryWithDictionary: myItems];
   }
   return self;
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void) loadView {
   [super loadView];
   UIView *newView = [[[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 460.0)] autorelease];
   [newView addSubview: self.view];
   self.tableView = (UITableView *) self.view;
   self.tableView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0 - 44.0);
   self.view = newView;

   UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, self.view.frame.size.height - 44.0, 320.0, 44.0)];
   
   UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
   
   UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel 
                                                                      target: self 
                                                                      action: @selector(cancel:)];
   UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave 
                                                                                 target: self 
                                                                                 action: @selector(saveItems:)];

   NSArray *buttonItems = [NSArray arrayWithObjects: spacer, cancelButton, saveButton, spacer, nil];
   [toolbar setItems: buttonItems];
   [cancelButton release];
   [saveButton release];
   [spacer release];
   [self.view addSubview: toolbar];
   [toolbar release];
   
   self.editing = YES;
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self sectionNames] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[self itemsInSection: section] count];
   if (self.editing) count++;
   return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ACDictionaryTableControllerCell";
    
    EditableCell *cell = (EditableCell *) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EditableCell alloc] initWithFrame: CGRectZero reuseIdentifier: CellIdentifier] autorelease];
    }
   if ([[self itemsInSection: indexPath.section] count] != indexPath.row) {
      cell.textField.text = [self itemForIndexPath: indexPath];      
   } else {
      cell.textField.text = @"";
   }
   cell.indexPath = indexPath;
   cell.textField.delegate = self;
   return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   // No editing style if not editing or the index path is nil.
   if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
   // Determine the editing style based on whether the cell is a placeholder for adding content or already 
   // existing content. Existing content can be deleted.
   NSArray *content = [self itemsInSection: indexPath.section];
   if (content) {
      if (indexPath.row >= [content count]) {
         return UITableViewCellEditingStyleInsert;
      } else {
         return UITableViewCellEditingStyleDelete;
      }
   }
   return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
   NSMutableArray *content = [self itemsInSection: indexPath.section];
   if (editingStyle == UITableViewCellEditingStyleDelete) {
      if (content && indexPath.row < [content count]) {
         [content removeObjectAtIndex:indexPath.row];
      }
      [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
   } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      [content addObject: @""];
      [aTableView insertRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationTop];
   }
}

#pragma mark Row reordering

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
   if (fromIndexPath.section == toIndexPath.section) {
      NSMutableArray *content = [self itemsInSection: fromIndexPath.section];
      if (content && toIndexPath.row < [content count]) {
         id item = [[content objectAtIndex:fromIndexPath.row] retain];
         [content removeObject:item];
         [content insertObject:item atIndex:toIndexPath.row];
         [item release];
      }
   }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
   // get the size of the content array
   NSUInteger numberOfRowsInSection = [[self itemsInSection: indexPath.section] count];
   // Don't allow the placeholder to be moved.
   return (indexPath.row < numberOfRowsInSection);
}
   
   // This allows the delegate to retarget the move destination to an index path of its choice. In this app, we don't want
   // the user to be able to move items from one group to another, or to the last row of its group (the last row is
   // reserved for the add-item placeholder).
   - (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
      NSUInteger sectionCount = [[self itemsInSection: sourceIndexPath.section] count];
   // Check to see if the source and destination sections match. If not, retarget to either the top of the source
   // section (if the destination is above the source) or the bottom of the source section if not.
   if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
      NSUInteger rowInSourceSection = (sourceIndexPath.section > proposedDestinationIndexPath.section) ? 0 : 
      sectionCount - 1;
      return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
      // Check for moving to the placeholder row. If so, retarget to just above that row.
   } else if (proposedDestinationIndexPath.row >= sectionCount) {
      return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
   }
   // Allow the proposed destination.
   return proposedDestinationIndexPath;
}
   
#pragma mark Saving

- (void) saveItems: (id) source {
   
   [delegate saveDictionary: self.items];
   [self dismissModalViewControllerAnimated: YES];   
}

- (void) cancel: (id) source {
   [self dismissModalViewControllerAnimated: YES];
}

#pragma mark Item Accessors

- (NSArray *) sectionNames {
   return (NSArray *) [self.items objectForKey: @"sections"];
}

- (NSString *) sectionName: (NSInteger) sectionIndex {
   return (NSString *) [[self sectionNames] objectAtIndex: sectionIndex];
}

- (NSMutableArray *) itemsInSection: (NSInteger)sectionIndex {
   return (NSMutableArray *) [[self.items objectForKey: @"items"] objectForKey: [self sectionName: sectionIndex]];
}

- (NSString *) itemForIndexPath: (NSIndexPath *)path {
   return (NSString *) [[self itemsInSection: path.section] objectAtIndex: path.row];
}

#pragma mark Memory

- (void)dealloc {
    [super dealloc];
}

#pragma mark TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
   [theTextField resignFirstResponder];
   return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   EditableCell *cell = (EditableCell *) [[textField superview] superview];
   NSMutableArray *itemsInSection = [self itemsInSection: cell.indexPath.section];
   if ([itemsInSection count] == cell.indexPath.row) {
      // It's the last row, which is the "+" row
#ifdef __IPHONE_3_0  
      [itemsInSection addObject: cell.textLabel.text];
#else
      [itemsInSection addObject: cell.text];
#endif
       [self.tableView reloadData];
   } else {
#ifdef __IPHONE_3_0
      [itemsInSection replaceObjectAtIndex: cell.indexPath.row withObject: cell.textLabel.text];      
#else
      [itemsInSection replaceObjectAtIndex: cell.indexPath.row withObject: cell.text];      
#endif
   }
}


@end

