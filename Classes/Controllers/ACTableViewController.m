
#import "ACTableViewController.h"
#import "SelectableTableItem.h"
#import "Constants.h"
#import "UINavigationController+Zest.h"
#import "UITableViewCellFixed.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Zest.h"

@implementation ACTableViewController

@synthesize items, sections, modelObject, newItemController, editController, showController, filterControl, sectionIndexTitles, editable;

#pragma mark Initialization


- (id)init {
	return [self initWithStyle: UITableViewStylePlain];   
}

- (id)initWithStyle: (UITableViewStyle) style {
	if (self = [super initWithStyle: style]) {
      self.items = [[NSMutableDictionary alloc] init];
      [items release]; // since we just alloced it
	}
	return self;   
}

- (id)initWithModelObject: (ARObject *)myModelObject {
   [self init];
   self.modelObject = myModelObject;
   return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
   if (self.editable) {
      // Add the built-in edit button item to the navigation bar. This item automatically toggles between
      // "Edit" and "Done" and updates the view controller's state accordingly.
      self.navigationItem.rightBarButtonItem = self.editButtonItem;
      self.tableView.allowsSelectionDuringEditing = YES;
   } else if (self.newItemController) {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd 
                                                                                              target: self 
                                                                                              action: @selector(addButtonPressed)] autorelease];
   }
}

#pragma mark Editing Methods


// If there is an editController, simply returns it.  For heterogeneous lists, subclasses can
// override this method
- (UIViewController <ACModelObjectController> *) editorForIndexPath:(NSIndexPath *)indexPath {
   return self.editController;
}

- (void) addButtonPressed {
   [self.newItemController setModelObject: nil];
   [self.navigationController pushViewController: self.newItemController animated: YES];
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
   
   if (editingStyle == UITableViewCellEditingStyleDelete) {
      NSMutableArray *itemsInSection = [self itemsInSection: indexPath.section];
      ARObject *selectedObject = (ARObject *)[self itemForIndexPath: indexPath];
      [selectedObject destroy];
      [itemsInSection removeObjectAtIndex: indexPath.row];
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
   }
}


- (BOOL) canAddItemsToSection: (NSInteger) section {
   return YES;
}

- (BOOL) canDeleteItemsInSection: (NSInteger) section {
   return YES;
}


// Set the editing state of the view controller. We pass this down to the table view and also modify the content
// of the table to insert a placeholder row for adding content when in editing mode.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
   [super setEditing:editing animated:animated];
   // Calculate the index paths for all of the placeholder rows based on the number of items in each section.
   NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
   NSInteger sectionIndex;
   NSInteger newRow;
   for (sectionIndex=0; sectionIndex < [items count]; sectionIndex++) {
      if ([self canAddItemsToSection: sectionIndex]) {
         newRow = [[self itemsInSection: sectionIndex] count];
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow: newRow inSection: sectionIndex];         
         [indexPaths addObject: indexPath];         
      }
   }
   [self.tableView beginUpdates];
   [self.tableView setEditing:editing animated: animated];
   if (editing) {
      // Show the placeholder rows
      [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
   } else {
      // Hide the placeholder rows.
      [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
   }
   [self.tableView endUpdates];
   [indexPaths release];
}

// Returns text to be placed in an add item cell.  
- (NSString *) addTextForSection: (NSInteger) sectionIndex {
   return @"Add item";
}



#pragma mark Item Accessors

- (void) setItems:(NSArray *)sectionItems forSection:(NSObject *)section {
   [self.items setObject: sectionItems forKey: section];
}

- (BOOL) hasOneSection {
   return [self numberOfSectionsInTableView: [self tableView]] == 1;
}

- (NSMutableArray *)itemsInSection:(NSInteger)section {
   NSObject *key;
   if ([self hasOneSection]) {
      NSArray *keys = [items allKeys];
      if (keys && [keys count] > 0) {
         key = [[items allKeys] objectAtIndex: 0];         
      } else {
         return [[[NSMutableArray alloc] init] autorelease];
      }
   } else {
      key = [sections objectAtIndex: section];
   }
   return (NSMutableArray *) [items objectForKey: key];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   if (self.sections == nil || [self.sections count] == 0) {
      return 1;      
   } else {
      return [self.sections count];
   }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)theTableView
{
	return sectionIndexTitles;		
}

- (NSObject *)itemForIndexPath: (NSIndexPath *) indexPath {
   return [[self itemsInSection: indexPath.section] objectAtIndex: indexPath.row];
}


#pragma mark TableView Delegate Methods


// Called after selection. In editing mode, this will navigate to a new view controller.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (self.editing) {
      UIViewController <ACModelObjectController> *editor = [self editorForIndexPath: indexPath];
      // Don't maintain the selection. We will navigate to a new view so there's no reason to keep the selection here.
      [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
      // Pass the item being edited to the editing controller.
      NSArray *content = [self itemsInSection: indexPath.section];
      if (content && indexPath.row < [content count]) {
         ARObject *selectedItem = (ARObject *) [self itemForIndexPath: indexPath];
         editor.modelObject = selectedItem;
      } else {
         // The row selected is a placeholder for adding content. The editor should create a new item, 
         // or the subclass of this controller should override the newModelObjectForEditor method
         editor.modelObject = [self newModelObjectForSection: indexPath.section];
      }
      [self.navigationController pushViewController: editor animated:YES];
   } else { // Not editing
      [self objectWasSelected: [self itemForIndexPath: indexPath]];
   }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSInteger count = [[self itemsInSection: section] count];
   if (self.editing && [self canAddItemsToSection: section]) count++;
   return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   if (self.sections != nil && [self.sections count] > 0) {
      return [self.sections objectAtIndex: section];
   }
   return nil;
}

- (UIFont *) cellDetailTextLabelFont {
   return [UIFont fontWithName: @"Helvetica" size: 14.0];
}

- (UIFont *) cellTextLabelFont {
   return [UIFont boldSystemFontOfSize: 18.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (theCell == nil) {
		theCell = [[[UITableViewCellFixed alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
		theCell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		theCell.detailTextLabel.numberOfLines = 0;
		theCell.detailTextLabel.font = [self cellDetailTextLabelFont];
		theCell.detailTextLabel.width = theCell.width - 20.0;
		theCell.textLabel.font = [self cellTextLabelFont];
		theCell.textLabel.numberOfLines = 1;
		theCell.textLabel.adjustsFontSizeToFitWidth = YES;

		[self configureCell:theCell];
	}
   [self populateCell: theCell forRowAtIndexPath: indexPath];
   return theCell;
}

#pragma mark Table Cell Methods


// Subclasses can implement this method to perform generic customization of cells before they're queued for reuse
- (void)configureCell:(UITableViewCell *)cell {
}

// Subclasses can implement this method to perform row-specific customization of the cell
- (void)populateCell:(UITableViewCell *)theCell forRowAtIndexPath:(NSIndexPath *)indexPath {
   NSArray *content = [self itemsInSection: indexPath.section];
   if (content && indexPath.row < [content count]) {
      // Configure the cell
      NSObject *cellItem = [self itemForIndexPath: indexPath];
      if ([cellItem isKindOfClass: [SelectableTableItem class]]) {
         theCell.imageView.image = [UIImage imageNamed: [(SelectableTableItem *)cellItem iconName]];
      }
      theCell.textLabel.text = [cellItem description];
      theCell.detailTextLabel.text = [cellItem detailDescription];
      theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

   } else {
      theCell.textLabel.text = [self addTextForSection: indexPath.section];
      theCell.detailTextLabel.text = nil;
   }
}

// The accessory view is on the right side of each cell. We'll use a "disclosure" indicator in editing mode,
// to indicate to the user that selecting the row will navigate to a new view where details can be edited.
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
   return (self.editing) ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
}*/

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   // No editing style if not editing or the index path is nil.
   if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
   NSArray *content = [self itemsInSection: indexPath.section];
   if (content) {
      if (indexPath.row >= [content count]) {
         return UITableViewCellEditingStyleInsert;
      } else if ([self canDeleteItemsInSection: indexPath.section]){
         return UITableViewCellEditingStyleDelete;
      }
   }
   return UITableViewCellEditingStyleNone;
}


#pragma mark Model Object Methods


- (ARObject *) newModelObjectForSection: (NSInteger) sectionIndex {
   return nil;
}

- (void)objectWasSelected: (NSObject *) selectedItem {
   if ([selectedItem isKindOfClass: [SelectableTableItem class]]) {
      SelectableTableItem *item = (SelectableTableItem *) selectedItem;
      [self performSelector: item.selector withObject: nil afterDelay: 0];
   } else if ([selectedItem isKindOfClass: [ARObject class]] && self.showController) {
      ARObject *selectedObject = (ARObject *) selectedItem;
      [self.showController setModelObject: selectedObject];
      [self.navigationController pushViewController: self.showController animated: YES];
   } else if (showController) {
      [self.navigationController pushViewController: self.showController animated: YES];      
   }
}

#pragma mark Search Filtering Methods

- (void) addTitleFilterWithItems: (NSArray *) segmentTextContent {
	filterControl = [[UISegmentedControl alloc] initWithItems: segmentTextContent];
	filterControl.selectedSegmentIndex = 0;
	filterControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	filterControl.segmentedControlStyle = UISegmentedControlStyleBar;
	filterControl.frame = CGRectMake(0, 0, 400, kCustomButtonHeight);
	[filterControl addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = filterControl;
}

- (void)filterAction:(id)sender {
}

#pragma mark View Delegate Methods

- (void)viewWillAppear:(BOOL)animated {
   [self.tableView reloadData];
	[super viewWillAppear:animated];
}

#pragma mark Memory Management

- (void)dealloc {
   self.sections = nil;
   self.sectionIndexTitles = nil;
   self.items = nil;
   self.editController = nil;
   self.filterControl = nil;
	[super dealloc];
}

#pragma mark Alerts 

- (void)alertWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: nil 
                                         cancelButtonTitle: @"Ok" 
                                         otherButtonTitles: nil];
   [alert show];
   [alert autorelease];   
}

- (void)confirmationWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: self 
                                         cancelButtonTitle: @"Cancel" 
                                         otherButtonTitles: @"Ok", nil];
   [alert show];
   [alert autorelease];   
}

#pragma mark Audio Methods

- (void) playSoundNamed: (NSString *)soundName {
      NSString *path = [[NSBundle mainBundle] pathForResource: soundName ofType: @"wav" inDirectory: nil];
      NSURL *soundURL =  [NSURL fileURLWithPath: path];
      SystemSoundID    mySSID;
      AudioServicesCreateSystemSoundID ((CFURLRef) soundURL, &mySSID);
      AudioServicesPlaySystemSound (mySSID);
}


@end

