//
//  DTSQLiteQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTSQLiteQuery.h"
#import "DTSQLiteQueryOperation.h"

@interface DTSQLiteQuery() 
@property (copy) NSString *sql;
@end


@implementation DTSQLiteQuery
@synthesize sql;

- (void) dealloc {
    [sql release];
    
    [super dealloc];
}

- (DTSQLiteQuery *)initWithSQL:(NSString *)newSQL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate {
    if ((self = (DTSQLiteQuery *)[super initQueryWithDelegate:newDelegate])) {
        self.sql = newSQL;
    }
    return self;
}

+ (DTSQLiteQuery *)queryWithSQL:(NSString *)sql delegate:(NSObject <DTAsyncQueryDelegate> *)delegate {
    return [[[self alloc] initWithSQL:sql delegate:delegate] autorelease];
}

// Subclasses must override this to construct and return custom query objects
- (DTAsyncQueryOperation *)constructQueryOperation {
    return [DTSQLiteQueryOperation operationWithSQL:sql delegate:self];
}

@end
