//
//  QueryResult.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/2/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"
#import "QueryRow.h"

@interface QueryResult : NSObject {
	NSMutableArray *rows;
	NSMutableArray *columnNames;
}

-(NSInteger) columnCount;
-(NSString *)columnName:(NSInteger)index;
-(QueryResult *)initWithStatement:(sqlite3_stmt *)statement operation:(NSOperation *)operation;
-(QueryRow *)firstRow;
-(QueryRow *)rowAtIndex:(NSInteger)index;
-(NSInteger)rowCount;
-(NSEnumerator *)rowEnumerator;
-(NSArray *)valuesForColumn:(NSString *)column;

@end
