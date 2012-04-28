//
//  DTHeterogeneousTableViewController.m
//  ProLog
//
//  Created by Christopher Garrett on 9/21/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTHeterogeneousSectionsTableViewController.h"


@implementation DTHeterogeneousSectionsTableViewController

@synthesize sectionNames, sectionHeights, cellNibNames, cellIdentifiers;

- (void)dealloc {
   [super dealloc];
}

// Subclasses should override this, call it first, and
// create their own cell nib names, section headers, and
// so forth

- (void)viewDidLoad {
   self.sectionNames = [NSArray array];
   self.cellNibNames = [NSArray array];
   self.cellIdentifiers = [NSMutableArray array];
   self.sectionHeights = [NSArray array];
   [super viewDidLoad];
}

- (void) viewDidUnload {
   self.sectionNames = nil;
   self.cellNibNames = nil;
   self.cellIdentifiers = nil;   
   self.sectionHeights = nil;   
}

#pragma mark Table cell methods

// Subclasses should override this.  
- (void) configureCell: (DTCustomTableViewCell *)unconfiguredCell atIndexPath: (NSIndexPath *) indexPath {
}

// By default, we assume that there is exactly one cell nib name per section, but you can override this method
// to do something else.  Return nil if you want to construct a cell at an index path using 
// contructCellAtIndexPath
- (NSString *) cellNibNameForIndexPath: (NSIndexPath *) indexPath {
   return [self.cellNibNames objectAtIndex: indexPath.section];
}

- (NSString *) cellIdentifierForIndexPath: (NSIndexPath *) indexPath {
   return [self.cellIdentifiers objectAtIndex: indexPath.section];
}

- (void) setCellIdentifier: (NSString *) identifier forIndexPath: (NSIndexPath *) indexPath {
   [self.cellIdentifiers replaceObjectAtIndex: indexPath.section withObject: identifier];
}


// Subclasses can override this to return a custom subclass of DTCustomTableViewCell with retain count 0 (autoreleased)
- (DTCustomTableViewCell *)constructCellForIndexPath: (NSIndexPath *)indexPath {
   return [[[DTCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: [self cellIdentifierForIndexPath: indexPath]] autorelease];
}

#pragma mark TableViewDataSource methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   return [self.sectionNames objectAtIndex: section];
}

#pragma mark TableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *cellIdentifier = [self cellIdentifierForIndexPath: indexPath];
      self.cell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (self.cell == nil) {
         NSString *nibName = [self cellNibNameForIndexPath: indexPath];
         if (nibName) {
            [[NSBundle mainBundle] loadNibNamed: nibName owner:self options:nil];
            [self setCellIdentifier: self.cell.reuseIdentifier forIndexPath: indexPath];
         } else {
            self.cell = [self constructCellForIndexPath: indexPath];
         }
      }
      [self configureCell: self.cell atIndexPath: indexPath];
      return self.cell;
}


// Subclasses can implement this to override the default data cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [[self.sectionHeights objectAtIndex: indexPath.section] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.sectionNames count];
}

@end

