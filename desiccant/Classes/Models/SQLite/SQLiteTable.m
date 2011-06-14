//
//  SQLiteTable.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/5/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "SQLiteTable.h"
#import "SQLiteConnectionAdapter.h"
#import "SQLiteColumn.h"

@implementation SQLiteTable
- (id) initWithName:(NSString *)myName
{
   if ((self = [super init])) {
      name = myName;
      columns = [[NSMutableDictionary alloc] init];
      SQLiteConnectionAdapter *connection = [SQLiteConnectionAdapter defaultInstance];
      QueryResult *result = [connection prepareAndExecute: [NSString stringWithFormat: @"PRAGMA table_info(%@)", name]];
      NSAssert1([result rowCount] > 0, @"No table info found for table named '%@'", name);
      QueryRow *row;
      NSString *columnName;
      SQLiteColumn *column;
      NSEnumerator *rowEnum = [result rowEnumerator];
      while (row = (QueryRow *)[rowEnum nextObject]) {
         columnName = [row stringValueForColumn: @"name"];
         column = [[SQLiteColumn alloc] initWithName: columnName typeName: [row stringValueForColumn: @"type"]];
         [columns setObject: column forKey: columnName];
      }
   }
   return self;
}

- (SQLiteColumn *)columnNamed: (NSString *)columnName
{
	return (SQLiteColumn *)[columns objectForKey: columnName];
}

- (NSEnumerator *)columnEnumerator
{
	return [columns objectEnumerator];
}

- (NSArray *)columnNames
{
	return [columns allKeys];
}

@end
