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
	SQLiteDatabaseException *result = [[[SQLiteDatabaseException alloc] initWithName: @"DatabaseException" reason: errorMessage userInfo: nil] autorelease];
	return result;
}

@end
