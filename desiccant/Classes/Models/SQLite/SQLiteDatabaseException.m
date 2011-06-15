//
//  SQLiteDatabaseException.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "SQLiteDatabaseException.h"


@implementation SQLiteDatabaseException
+ (SQLiteDatabaseException *)exceptionFromSQLite: (sqlite3 *)connection
{
	NSString *errorMessage = [NSString stringWithFormat: @"Database Error '%s'.", sqlite3_errmsg(connection)];
   NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: errorMessage,  NSLocalizedDescriptionKey, nil];
	SQLiteDatabaseException *result = [[[SQLiteDatabaseException alloc] initWithDomain: @"SQLite" code: 1 userInfo: userInfo] autorelease];
	return result;
}

@end
