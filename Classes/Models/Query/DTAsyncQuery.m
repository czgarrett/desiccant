//
//  ACAsyncQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//


#import "DTAsyncQuery.h"
#import "DTTransformsUntypedData.h"
#import "DTFiltersUntypedData.h"

#pragma mark Private Interface
@interface DTAsyncQuery()
@property (nonatomic, retain) NSArray *rawRows;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSOperationQueue *operationQueue;    
@property (nonatomic) BOOL updating;
@property (nonatomic) BOOL loaded;
@property (nonatomic, retain) NSMutableArray *rowTransformers;
@property (nonatomic, retain) NSMutableArray *rowFilters;
- (void)transformRawRows;
- (void)filterTransformedRows;
- (void)groupRows;
@end


#pragma mark Class Implementation
@implementation DTAsyncQuery

@synthesize 
rawRows, rows, groups, operationQueue, delegate, updating, loaded, rowTransformers, rowFilters, grouper, error;
/*
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
 */
- (void)dealloc {
    [rawRows release];
    [rows release];
    [groups release];
    [operationQueue release];
    [delegate release];
    [rowTransformers release];
    [rowFilters release];
    [grouper release];
    [error release];
    
    [super dealloc];
}

- (id)initQueryWithDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate {
    if (self = [super init]) {
        [self clear];
        self.delegate = newDelegate;
        [self.operationQueue = [[NSOperationQueue alloc] init] release];
        [self clearRowTransformers];
        [self clearRowFilters];
    }
    return self;
}

// Subclasses must override this to construct and return custom query objects with retain count 0 (autoreleased)
- (DTAsyncQueryOperation *)constructQueryOperation {
    return [DTAsyncQueryOperation operationWithDelegate:self];
}

- (void)addRowTransformer:(NSObject <DTTransformsUntypedData> *)transformer {
    [rowTransformers addObject:transformer];
}

- (void)clearRowTransformers {
    self.rowTransformers = [NSMutableArray arrayWithCapacity:1];
}

- (void)addRowFilter:(NSObject <DTFiltersUntypedData> *)filter {
    [rowFilters addObject:filter];
}

- (void)clearRowFilters {
    self.rowFilters = [NSMutableArray arrayWithCapacity:1];
}

- (void)clear {
    self.loaded = NO;
    self.rawRows = [NSArray array];
    self.rows = [NSMutableArray array];
    self.groups = [NSMutableArray array];
}

- (void)refresh {
    if (self.updating) {
        return;
    }
    else {
        self.updating = YES;
    }
	[operationQueue addOperation:[self constructQueryOperation]];
}

- (NSMutableDictionary *)itemAtIndex:(NSUInteger)index {
	return index < [self.rows count] ? (NSMutableDictionary *)[self.rows objectAtIndex:index] : nil;
}

- (NSMutableDictionary *)itemAtIndex:(NSUInteger)rowIndex inGroupWithIndex:(NSUInteger)groupIndex {
    return [self groupCount] == 1 ? [self itemAtIndex:rowIndex] : (NSMutableDictionary *)[(NSMutableArray *)[self.groups objectAtIndex:groupIndex] objectAtIndex:rowIndex];
}

- (NSUInteger)count {
    return [rows count];
}

- (NSUInteger)rowCountForGroupWithIndex:(NSUInteger)index {
    return [self groupCount] == 1 ? [self count] : [(NSMutableArray *)[groups objectAtIndex:index] count];
}

- (NSUInteger)groupCount {
    return groups && [groups count] > 0 ? [groups count] : 1;
}

// Subclasses can implement this if they want to have indexes along the right side
- (NSArray *)groupIndexes {
    return nil;
}

// Subclasses can implement this if they want to have headers above each section
- (NSString *)titleForGroupWithIndex:(NSUInteger)index {
    return nil;
}

- (void)postProcessRawRows {
    [self transformRawRows];
    [self filterTransformedRows];
    [self groupRows];
}

- (void)transformRawRows {
    self.rows = [NSMutableArray arrayWithCapacity:[rawRows count]];
    for (NSMutableDictionary *row in self.rawRows) {
        NSMutableDictionary *newRow = [[row mutableCopy] autorelease];
        for (NSObject <DTTransformsUntypedData> *transformer in rowTransformers) {
            [transformer transform:newRow];
        }
        [rows addObject:newRow];
    }
}

- (void)filterTransformedRows {
    for (NSObject <DTFiltersUntypedData> *filter in rowFilters) {
        for (NSInteger index = [rows count] - 1; index >= 0; index--) {
            if ([filter rejectsRow:[rows objectAtIndex:index]]) {
                [rows removeObjectAtIndex:index];
            }
        }
    }
}

- (void)groupRows {
    self.groups = [NSMutableArray arrayWithCapacity:[rows count]];
    if (grouper) {
        [grouper groupRows:rows into:groups];
    }
}

- (void)operationWillStartLoading:(DTAsyncQueryOperation *)query {
    [delegate queryWillStartLoading:self];
}

- (void)operationDidFinishLoading:(DTAsyncQueryOperation *)query {
    self.rawRows = query.rows;
    [self postProcessRawRows];
    self.loaded = YES;
    [delegate queryDidFinishLoading:self];
    self.updating = NO;
}

- (void)operationDidFailLoading:(DTAsyncQueryOperation *)query {
    self.error = [query error];
    [delegate queryDidFailLoading:self];
    self.updating = NO;
}



@end
