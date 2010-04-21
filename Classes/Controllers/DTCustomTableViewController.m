//
//  ACCustomTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCustomTableViewController.h"
#import "Zest.h"

@interface DTCustomTableViewController()
@end

@implementation DTCustomTableViewController
@synthesize cellNibName, cellIdentifier, headerRows;

- (void)dealloc {
   self.cellNibName = nil;
   self.cellIdentifier = nil;
   NSLog(@"DTCustomTableViewController dealloc");
   [super dealloc];
}

- (void)viewDidLoad {
    self.cellIdentifier = [NSString stringWithFormat:@"cell_type_%d", [DTCustomTableViewController nextIdentifierNumber]];
   headerRows = 0;
    [super viewDidLoad];
}

//- (void)beforeViewDidLoad:(UITableView *)theTableView {
//    self.cellIdentifier = [NSString stringWithFormat:@"cell_type_%d", [DTCustomTableViewController nextIdentifierNumber]];
//	[super beforeViewDidLoad:theTableView];
//}

+ (NSInteger)nextIdentifierNumber {
    static NSInteger number = 0;
    return ++number;
}

#pragma mark Table cell methods

// Subclasses can implement this to change the look & feel of any cell.  This is only called if cellNibName is not set. 
- (void)customizeCell {
}

// Subclasses should override this.  
- (void) configureCell: (DTCustomTableViewCell *)unconfiguredCell atIndexPath: (NSIndexPath *) indexPath {
}

// Subclasses can override this to return a custom subclass of DTCustomTableViewCell with retain count 0 (autoreleased)
- (DTCustomTableViewCell *)constructCell {
    return [[[DTCustomTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *theCell = nil;
   if ([self indexPathIsHeader:indexPath]) {
      theCell = [self headerRowForIndexPath:indexPath];
   } else {
      NSAssert(cellIdentifier != nil, @"Cell identifier has not been set.  Check yer code!");
      cell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (cell == nil) {
         if (self.cellNibName) {
            [[NSBundle mainBundle] loadNibNamed:self.cellNibName owner:self options:nil];
            self.cellIdentifier = cell.reuseIdentifier;
            NSAssert(cellIdentifier != nil, @"Cell identifier must be set in Interface Builder when using cells this way.");
            [cell retain];
         } else {
            self.cell = [self constructCell];
            [self customizeCell];
         }
      } 
      indexPath = [self adjustIndexPathForHeaders:indexPath];
      [self configureCell: cell atIndexPath: indexPath];
      theCell = cell;
   }    
   return theCell;
}


#pragma mark Header support

// Subclasses must implement this to return a header cell if headerRows > 0
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath {
   return nil;
}

- (BOOL)hasHeaders {
   return headerRows > 0;
}

- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath {
   return [NSIndexPath indexPathForRow:indexPath.row inSection:[self adjustSectionForHeaders:indexPath.section]];
}

- (NSInteger)adjustSectionForHeaders:(NSInteger)section {
   return ([self hasHeaders] && section > 0) ? section - 1 : section;
}

- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath {
   return [self hasHeaders] && indexPath.section == 0;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
   return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   return nil;
}


// Subclasses can implement this to override the default header row height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderRowAtIndexPath:(NSIndexPath *)indexPath {
   return 44.0;
}

// Subclasses can implement this to override the default data cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForDataRowAtIndexPath:(NSIndexPath *)indexPath {
     return 44.0;
}


@end
