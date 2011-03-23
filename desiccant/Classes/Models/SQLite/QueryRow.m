//
//  QueryRow.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/4/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "QueryRow.h"
#import "QueryResult.h"

@implementation QueryRow

- (id)init
{
	if ((self = [super init])) {
		columnDictionary = [[NSMutableDictionary alloc] init];
	}
   return self;
}

- (id)initWithStatement: (sqlite3_stmt *)statement result: (QueryResult *)result
{
	[self init];
	for (int column=0; column < [result columnCount]; column++) {
		NSObject *value;
	   switch (sqlite3_column_type(statement, column)) {
			case SQLITE_INTEGER:
				value = [[NSNumber alloc] initWithLongLong: sqlite3_column_int64(statement, column)];
				break;
			case SQLITE_FLOAT:
				value = [[NSNumber alloc] initWithDouble: sqlite3_column_double(statement, column)];
				break;
			case SQLITE_TEXT:
				value = [[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, column)];
//               DTLog([NSString stringWithFormat:@"+ Column %d: %s", column, sqlite3_column_text(statement, column)]);
				break;
			case SQLITE_BLOB:
				value =nil;
				break;
			case SQLITE_NULL:
				value = nil;
				break;	
         default:
            NSAssert(NO, @"Unsupported SQLite type!");
		}
      if(value) {
         [columnDictionary setObject: value forKey: [result columnName: column]];
         [value release];
      }
	}
	return self;
}

- (void)dealloc
{
	[columnDictionary release];
	[super dealloc];
}

- (NSObject *) valueForColumn: (NSString *)columnName
{
   return [columnDictionary objectForKey: columnName];
}

- (NSInteger) integerValueForColumn: (NSString *)columnName
{
	NSNumber *value = [columnDictionary objectForKey: columnName];
	if (value) {
		return [value integerValue];		
	} else {
		return 0;
	}
}

- (NSString *) stringValueForColumn: (NSString *)columnName
{
	NSString *value = [columnDictionary objectForKey: columnName];
	return value;		
}

- (NSDictionary *)columnValues
{
	return columnDictionary;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"QueryRow values: %@", columnDictionary];
}

@end
