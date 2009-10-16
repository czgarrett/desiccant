//
//  DTAsyncQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAsyncQueryOperationDelegate.h"
#import "DTTransformsUntypedData.h"
#import "DTFiltersUntypedData.h"
#import "DTGroupsUntypedData.h"

@protocol DTAsyncQueryDelegate;

@interface DTAsyncQuery : NSObject <DTAsyncQueryOperationDelegate, NSFastEnumeration> {
    NSArray *rawRows;
    NSMutableArray *rows;
    NSMutableArray *groups;
    NSOperationQueue *operationQueue;    
    BOOL updating;
    BOOL loaded;
    NSObject <DTAsyncQueryDelegate> *delegate;
    NSMutableArray *rowTransformers;
    NSMutableArray *rowFilters;
    NSObject <DTGroupsUntypedData> *grouper;
    NSString *error;
}

- (id)initQueryWithDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate;

// Subclasses must override this to construct and return custom query objects
- (DTAsyncQueryOperation *)constructQueryOperation;
// Subclasses can implement this if they want to have indexes along the right side
- (NSArray *)groupIndexes;
// Subclasses can implement this if they want to have headers above each section
- (NSString *)titleForGroupWithIndex:(NSUInteger)index;
// Use this to append to a chain of objects that will post-process queried rows, adding or changing fields as necessary
- (void)addRowTransformer:(NSObject <DTTransformsUntypedData> *)transformer;
- (void)clearRowTransformers;
- (void)addRowFilter:(NSObject <DTFiltersUntypedData> *)filter;
- (void)clearRowFilters;
- (void)clear;
- (void)refresh;
- (NSUInteger)count;
- (NSUInteger)groupCount;
- (NSUInteger)rowCountForGroupWithIndex:(NSUInteger)index;
- (NSMutableDictionary *)itemAtIndex:(NSUInteger)index;
- (NSMutableDictionary *)itemAtIndex:(NSUInteger)rowIndex inGroupWithIndex:(NSUInteger)groupIndex;

@property (retain) NSObject <DTAsyncQueryDelegate> *delegate;
@property (nonatomic, retain) NSObject <DTGroupsUntypedData> *grouper;
@property (nonatomic, readonly) BOOL updating;
@property (nonatomic, readonly) BOOL loaded;
@property (nonatomic, copy)  NSString *error;

@end

#import "DTAsyncQueryDelegate.h"