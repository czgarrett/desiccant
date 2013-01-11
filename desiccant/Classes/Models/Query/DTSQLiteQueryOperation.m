//
//  DTSQLiteQueryOperation.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSQLiteQueryOperation.h"
#import "QueryResult.h"
#import "QueryRow.h"
#import "SQLiteConnectionAdapter.h"

@interface DTSQLiteQueryOperation()
@property (copy) NSString *sql;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSString *error;
@end


@implementation DTSQLiteQueryOperation
@synthesize sql, rows, error;

- (void)dealloc {
    [sql release];
    [rows release];
    [error release];
    
    [super dealloc];
}

- (id) initWithSQL:(NSString *)newSQL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate {
    if ((self = [super initWithDelegate:newDelegate])) {
        self.sql = newSQL;
        self.rows = [NSMutableArray array];
    }
    return self;
}

+ (DTSQLiteQueryOperation *) operationWithSQL:(NSString *)sql delegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate {
    return [[[self alloc] initWithSQL:sql delegate:delegate] autorelease];
}

// Subclasses should override this to execute the query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery {
    QueryResult *result = [[SQLiteConnectionAdapter defaultInstance] prepareAndExecute:sql];
    for (NSInteger rowIndex = 0; rowIndex < [result rowCount]; rowIndex++) {
        NSMutableDictionary * data = [NSMutableDictionary dictionary];
        for (NSInteger columnIndex = 0; columnIndex < [result columnCount]; columnIndex++) {
//            DTLog([NSString stringWithFormat:@"- %@: %@", [result columnName:columnIndex], [[result rowAtIndex:rowIndex] stringValueForColumn:[result columnName:columnIndex]]]);
            [data setValue:[[result rowAtIndex:rowIndex] stringValueForColumn:[result columnName:columnIndex]] forKey:[result columnName:columnIndex]];
        }
        [rows addObject:data];
    }
    return YES;
}

@end
