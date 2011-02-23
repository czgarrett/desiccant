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
#import "DTSortsUntypedData.h"

@class DTAsyncQuery, DTAsyncQueryOperation;
@protocol DTAsyncQueryDelegate

- (void)queryDidFinishLoading:(DTAsyncQuery *)query;
- (void)queryDidFailLoading:(DTAsyncQuery *)query;

@optional
- (void)queryWillStartLoading:(DTAsyncQuery *)query;
- (void)queryDidCancelLoading:(DTAsyncQuery *)query;
- (void)queryWillStartLoadingMoreResults:(DTAsyncQuery *)query;
- (void)queryDidFinishLoadingMoreResults:(DTAsyncQuery *)query;
- (void)queryDidCancelLoadingMoreResults:(DTAsyncQuery *)query;
- (void)queryDidFailLoadingMoreResults:(DTAsyncQuery *)query;

@end

@protocol DTAsyncQueryOperationDelegate;

@interface DTAsyncQuery : NSObject <DTAsyncQueryOperationDelegate, NSFastEnumeration, DTAsyncQueryDelegate> {
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
	NSObject <DTSortsUntypedData> *rowSorter;
    NSString *error;
	DTAsyncQueryOperation *operation;
	DTAsyncQuery *moreResultsQuery;
}

- (id)initQueryWithDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate;

// Subclasses must override this to construct and return custom query objects
- (DTAsyncQueryOperation *)constructQueryOperation;
// Subclasses can implement this if they want to have indexes along the right side
- (NSArray *)groupIndexes;
// Subclasses can implement this if they want to have headers above each section
- (NSString *)titleForGroupWithIndex:(NSUInteger)index;
// Subclasses can implement this to return detailed cursor data if there are more results available
- (NSDictionary *)cursorData;
// Subclasses may override this and set the moreResultsQuery property if another page of results can be loaded after this one.
// If no more results can be lodaed, this method should set moreResultsQuery to nil.
- (void)loadMoreResultsQuery;
// Use this to append to a chain of objects that will post-process queried rows, 
// adding or changing fields as necessary.
// Retains the added object, so release it to prevent circular references if necessary.
- (void)addRowTransformer:(NSObject <DTTransformsUntypedData> *)transformer;
- (void)clearRowTransformers;
// Use this to append to a chain of objects that will filter queried rows, 
// deciding whether or not each row should be included in the results.
// Retains the added object, so release it to prevent circular references if necessary.
- (void)addRowFilter:(NSObject <DTFiltersUntypedData> *)filter;
- (void)clearRowFilters;
- (void)clear;
- (void)refresh;
- (NSUInteger)count;
- (NSUInteger)groupCount;
- (NSUInteger)rowCountForGroupWithIndex:(NSUInteger)index;
- (NSMutableDictionary *)itemAtIndex:(NSUInteger)index;
- (NSMutableDictionary *)itemAtIndex:(NSUInteger)rowIndex inGroupWithIndex:(NSUInteger)groupIndex;
- (void)deleteItemAtIndex:(NSUInteger)index;
- (void)deleteItemAtIndex:(NSUInteger)index inGroupWithIndex:(NSUInteger)groupIndex;
- (void)cancel;
- (BOOL)isCancelled;
- (BOOL)hasMoreResults;
- (void)fetchMoreResults;

@property (retain) NSObject <DTAsyncQueryDelegate> *delegate;
// If not nil, rowSorter will be called to sort transformed/filtered rows
// Retains.  Release manually to prevent circular references if necessaqry.
@property (nonatomic, retain) NSObject <DTSortsUntypedData> *rowSorter;
// If not nil, grouper will be called to group transformed/filtered/sorted rows
// Retains.  Release manually to prevent circular references if necessaqry.
@property (nonatomic, retain) NSObject <DTGroupsUntypedData> *grouper;  
@property (nonatomic, readonly) BOOL updating;
@property (nonatomic, readonly) BOOL loaded;
@property (nonatomic, copy)  NSString *error;
@property (nonatomic, retain) DTAsyncQuery *moreResultsQuery;
//@property (nonatomic, retain) DTAsyncQueryOperation *operation;

@end
