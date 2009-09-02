//
//  DTSQLiteQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAsyncQuery.h"

@interface DTSQLiteQuery : DTAsyncQuery {
    NSString *sql;
}

@property (readonly, copy) NSString *sql;

+ (DTSQLiteQuery *)queryWithSQL:(NSString *)sql delegate:(NSObject <DTAsyncQueryDelegate> *)delegate;

@end
