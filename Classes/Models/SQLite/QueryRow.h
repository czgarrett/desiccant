//
//  QueryRow.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/4/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

@class QueryResult;

@interface QueryRow : NSObject {
	NSMutableDictionary *columnDictionary;
}
- initWithStatement: (sqlite3_stmt *)statement result: (QueryResult *)result;
- (NSObject *) valueForColumn: (NSString *)columnName;
- (NSInteger) integerValueForColumn: (NSString *)columnName;
- (NSString *) stringValueForColumn: (NSString *)columnName;
- (NSDictionary *)columnValues;
@end
