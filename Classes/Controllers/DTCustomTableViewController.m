//
//  ACCustomTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCustomTableViewController.h"

@interface DTCustomTableViewController()
+ (NSInteger)nextIdentifierNumber;
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
   if ([self indexPathIsHeader:indexPath]) {
      return [self headerRowForIndexPath:indexPath];
   }
   else {
      tempCell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (tempCell == nil) {
         if (self.cellNibName) {
            [[NSBundle mainBundle] loadNibNamed:self.cellNibName owner:self options:nil];
            self.cellIdentifier = tempCell.reuseIdentifier;
            [tempCell retain];
         } else {
            self.tempCell = [self constructCell];
            [self customizeCell];
         }
      }
      indexPath = [self adjustIndexPathForHeaders:indexPath];
      [self configureCell: tempCell atIndexPath: indexPath];
      return tempCell;
   }    
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
