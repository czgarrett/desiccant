//
//  ACSearchListDataSource.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/10/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDataSourceDelegate.h"
#import "ARObject.h"

#define kMaxRows 50

@interface ACSearchListDataSource : NSOperation <UITableViewDataSource> {
   Class activeRecordClass;
   NSArray *sectionHeadings;
	NSArray *queryResult; // Each section is an array of Guests retrieved from the database
	id <TableViewDataSourceDelegate> delegate;
	UITableView *tableView;
   
   // Search-related
   // The column to query on with the text filter
   NSString *queryColumn;
   // The column from which results will be returned
   NSString *resultsColumn;
   // A condition to be injected into the SQL where clause
   NSString *condition;
   // The column to order the results by
   NSString *orderColumn;
   // Maximum number of results
   NSInteger searchLimit;
   NSInteger sectionSize;
	NSString *searchFilter;
	
	BOOL empty;
   BOOL tooMany;
}

@property(retain) NSArray *queryResult;
@property(retain) NSArray *sectionHeadings;
@property(nonatomic, retain) NSString *queryColumn;
@property(nonatomic, retain) NSString *condition;
@property(nonatomic, retain) NSString *orderColumn;
@property(nonatomic, retain) NSString *resultsColumn;
@property(nonatomic, assign) Class activeRecordClass;
@property(nonatomic, assign) NSInteger searchLimit;
@property(nonatomic, assign) BOOL empty;

- (id) initWithTableView:(UITableView *)tableView 
         textFilter:(NSString *)textfilter 
       activeRecordClass: (Class) activeRecordClass
         delegate: (id <TableViewDataSourceDelegate>) delegate;
- (NSString *)textForSection:(NSInteger)section row:(NSInteger)row;
- (ARObject *)objectForSection:(NSInteger)section row:(NSInteger)row;
- (NSInteger) count;

@end
