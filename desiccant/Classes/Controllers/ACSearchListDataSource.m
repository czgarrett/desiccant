//
//  ACSearchListDataSource.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/10/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "ACSearchListDataSource.h"
#import "ARObject.h"

#define INDEX_WORD_LENGTH 6


@implementation ACSearchListDataSource

@synthesize queryResult, sectionHeadings, queryColumn, activeRecordClass, searchLimit, condition, orderColumn, resultsColumn, empty;

- (id) initWithTableView: (UITableView *)newTableView 
              textFilter: (NSString *)newSearchFilter 
       activeRecordClass: (Class) myActiveRecordClass
                delegate: (id <TableViewDataSourceDelegate>) newDelegate
{
	if (self = [super init]) {
      delegate = newDelegate;
      if (newSearchFilter && [newSearchFilter length] > 0) {
	      searchFilter = [newSearchFilter lowercaseString];	
      } else {
         searchFilter = @"a";
		}
      condition = @"1";
      activeRecordClass = myActiveRecordClass;
		[searchFilter retain];
      tableView = newTableView;
      [tableView retain];
      searchLimit = 100;
      empty = YES;
      tooMany = NO;
   }
	return self;
}

- (void) executeSearchQuery {
   NSString *sql = [NSString stringWithFormat: @"(%@) and %@ >= (select %@ from %@ where %@ >= ? limit 1) order by %@ limit %d", 
                    self.condition,
                    self.orderColumn,
                    self.orderColumn,
                    [[self.activeRecordClass class] tableName], 
                    self.queryColumn, 
                    self.orderColumn, 
                    searchLimit];
   self.queryResult = [[self.activeRecordClass class] usingOperation: self 
                                                 findValuesForColumn: self.resultsColumn
                                                       withCondition: sql, searchFilter];
}
 
- (void) main
{
   @synchronized(delegate) {
      if (![self isCancelled]) {
         NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
         NSMutableArray *newSectionHeadings = [[NSMutableArray alloc] init];
         [self executeSearchQuery];
         if ([self isCancelled]) {
            empty = YES;
         } else {
            if ([self.queryResult count] > kMaxRows) {
               tooMany = YES;
               empty = NO;
            } else {
               tooMany = NO;
            }
            empty = [self.queryResult count] == 0;
            if ([self.queryResult count] > 50) {
               sectionSize = [self.queryResult count] / 25;
               if (sectionSize < 10) sectionSize = 10;
               for (int i=0; i<[self.queryResult count] && ![self isCancelled]; i+=sectionSize) {
                  NSString *startFull = [[self.queryResult objectAtIndex: i] description]; 
                  NSString *start = [startFull substringToIndex: MIN([startFull length], INDEX_WORD_LENGTH)];
                  NSString *endFull = [[self.queryResult objectAtIndex: MIN(i+sectionSize-1, [self.queryResult count] - 1)] description]; 
                  NSString *end = [endFull substringToIndex: MIN([endFull length], INDEX_WORD_LENGTH)];
                  NSString *header = [NSString stringWithFormat: @"%@ - %@", start, end];
                  [newSectionHeadings addObject: header];
               }
            }
            if (![self isCancelled]) {
               [(NSObject *) delegate performSelectorOnMainThread:@selector(dataSourceIsReady:) withObject: self waitUntilDone: YES];            
            }
         }
         self.sectionHeadings = newSectionHeadings;
         [newSectionHeadings release];
         [pool release];
      }
   }
}

- (void) cancel {
   [super cancel];
}

- (void) dealloc
{
   self.sectionHeadings = nil;
   self.queryResult = nil;
	[searchFilter release];
   [tableView release];
   [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) theTableView
{
   return MAX([sectionHeadings count], 1);		      
}

- (NSString *)textForSection:(NSInteger)section row:(NSInteger)rowIndex
{
	if (empty) {
		return @"";
	} else {
      NSObject *object = [self.queryResult objectAtIndex: (section * sectionSize + rowIndex)];
      return [object description];
	}
}

- (ARObject *)objectForSection:(NSInteger)section row:(NSInteger)rowIndex
{
	if (empty) {
		return nil;
	} else {
		NSString *sql = [NSString stringWithFormat: @"(%@) and %@ >= (select %@ from %@ where %@ >= ? limit 1) order by %@ limit 1 offset %d", 
                       self.condition,
							  self.orderColumn,
							  self.orderColumn,
							  [[self.activeRecordClass class] tableName], 
							  self.queryColumn, 
							  self.orderColumn, 
							  (long) rowIndex];
		
      ARObject *result =  [[activeRecordClass class] findFirstByCondition: sql, searchFilter];
		return result;
	}
}



- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger) section
{
	if (empty) {
		return 0;
	} else if ([sectionHeadings count] == 0) {
      return [self.queryResult count];
   } else if (section == [sectionHeadings count] - 1) {
      return [self.queryResult count] - sectionSize * section;
   } else {
      return sectionSize;
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)theTableView
{
	return sectionHeadings;		
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section
{
	if (empty) {
		return @"No results found";
   } else if ([sectionHeadings count] == 0) {
      return nil;
   } else {
		return (NSString *)[sectionHeadings objectAtIndex: section];		
	}
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UILabel *nameLabel;
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: @"SearchResult"];
	if (!cell) {
		// Since the cell will be sized automatically, we can pass the zero rect for the frame
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"SearchResult"] autorelease];
      cell.opaque = YES;
      
      nameLabel = [[[UILabel alloc] initWithFrame: CGRectMake(35.0, 0.0, 320.0, 40.0)] autorelease];
      nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      nameLabel.tag = 2;
      nameLabel.font = [UIFont boldSystemFontOfSize: 18.0];
      [cell.contentView addSubview: nameLabel];
	} else {
      nameLabel = (UILabel *)[cell.contentView viewWithTag: 2];
   }
   
	nameLabel.text = [self textForSection: [indexPath section] row: [indexPath row]];
   
	return cell;
}

- (NSInteger) count
{
   if (self.queryResult) {
      return [self.queryResult count];      
   } else {
      return 0;
   }
}


@end
