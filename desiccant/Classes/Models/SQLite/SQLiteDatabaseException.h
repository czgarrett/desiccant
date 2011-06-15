//
//  SQLiteDatabaseException.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface SQLiteDatabaseException : NSError {

}
+ (SQLiteDatabaseException *)exceptionFromSQLite: (sqlite3 *)connection;

@end
