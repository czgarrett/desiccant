//
//  QueryResult.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/2/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "QueryResult.h"
#import "SQLiteConnectionAdapter.h"
#import "Zest.h"

@implementation QueryResult

-(id)init
{
	if ((self = [super init])) {
		rows = [[NSMutableArray alloc] init];
		columnNames = [[NSMutableArray alloc] init];
	}
   return self;
}

-(QueryResult *)initWithStatement:(sqlite3_stmt *)statement operation:(NSOperation *)operation
{
	[self init];
	QueryRow *row;
	int columnCount = 0;
	int execResult = sqlite3_step(statement);
	// The columns will be same for the whole result set, so we build them up here
	if (execResult == SQLITE_ROW) {
		columnCount = sqlite3_column_count(statement);
		for (int column = 0; column < columnCount; column++) {
			NSString *columnName = [[NSString alloc] initWithUTF8String: (char *)sqlite3_column_name(statement, column)];
			[columnNames addObject: columnName];
         [columnName release];
		}
	}
	while (execResult == SQLITE_ROW && !(operation && [operation isCancelled])) {		
		row = [[QueryRow alloc] initWithStatement: statement result: self];
		[rows addObject: row];			
		[row release];
		execResult = sqlite3_step(statement);
	}
   // Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
   sqlite3_reset(statement);
   if (execResult == SQLITE_ERROR) {
		[[SQLiteConnectionAdapter defaultInstance] handleSQLiteError];
   }
   if (execResult == SQLITE_READONLY) {
      DTLog(@"Attempted to write to a read-only database!");
   }
   if(operation && [operation isCancelled]) {
      [rows removeAllObjects];
   }
   return self;	
}

-(void)dealloc
{
	[rows release];
	[columnNames release];
	[super dealloc];
}


- (NSInteger)columnCount
{
	return [columnNames count];
}

- (NSString *)columnName: (NSInteger)index;
{
	return (NSString *)[columnNames objectAtIndex: index];
}

- (QueryRow *) firstRow
{
	return (QueryRow *) [rows objectAtIndex: 0];
}

- (NSInteger) rowCount
{
	return [rows count];
}

-(QueryRow *)rowAtIndex:(NSInteger)index
{
   return (QueryRow *)[rows objectAtIndex: index];
}


- (NSEnumerator *)rowEnumerator
{
	return [rows objectEnumerator];
}

-(NSArray *)valuesForColumn:(NSString *)column {
   NSEnumerator *rowEnumerator = [self rowEnumerator];
   NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
   QueryRow *currentRow;
   while (currentRow = (QueryRow *)[rowEnumerator nextObject]) {
      [result addObject: [currentRow valueForColumn: column]];
   }
   return result;
}

@end
