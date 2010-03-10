//
//  DTAsyncQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//


#import "DTAsyncQuery.h"
#import "Zest.h"

#pragma mark Private Interface
@interface DTAsyncQuery()
@property (nonatomic, retain) NSArray *rawRows;
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSOperationQueue *operationQueue;    
@property (nonatomic) BOOL updating;
@property (nonatomic) BOOL loaded;
@property (nonatomic, retain) NSMutableArray *rowTransformers;
@property (nonatomic, retain) NSMutableArray *rowFilters;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) DTAsyncQueryOperation *operation;
- (void)transformRawRows;
- (void)filterTransformedRows;
- (void)groupRows;
- (void)sortRows;
- (void)postProcessRawRows;
@end


#pragma mark Class Implementation
@implementation DTAsyncQuery
@synthesize rows, rawRows, groups, operationQueue, delegate, updating, loaded, rowTransformers, rowFilters, grouper, rowSorter, error, operation, moreResultsQuery;

#pragma mark Memory management

- (void)dealloc {
	self.rawRows = nil;
	self.rows = nil;
	self.groups = nil;
	self.operationQueue = nil;
	self.delegate = nil;
	self.rowTransformers = nil;
	self.rowFilters = nil;
	self.grouper = nil;
	self.rowSorter = nil;
	self.error = nil;
	self.operation.delegate = nil;
	self.operation = nil;
	self.moreResultsQuery = nil;
    
    [super dealloc];
}

#pragma mark Constructors

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

#pragma mark Public methods

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

- (void)deleteItemAtIndex:(NSUInteger)index {
	NSMutableDictionary *item = [self itemAtIndex:index];
	[rows removeObjectAtIndex:index];
	for (NSMutableArray *group in groups) {
		if ([group containsObject:item]) {
			[group removeObject:item];
		}
	}
}

- (void)deleteItemAtIndex:(NSUInteger)index inGroupWithIndex:(NSUInteger)groupIndex {
	NSMutableDictionary *item = [self itemAtIndex:index inGroupWithIndex:groupIndex];
	[rows removeObject:item];
	[[groups objectAtIndex:groupIndex] removeObjectAtIndex:index];
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

- (void)cancel {
	if (loaded && self.moreResultsQuery) {
		[self.moreResultsQuery cancel];
	}
	else {
		[self.operation cancel];
	}
}

- (BOOL)isCancelled {
	return [self.operation isCancelled];
}

- (BOOL)hasMoreResults {
	return self.moreResultsQuery != nil;
}

- (void)fetchMoreResults {
	if (self.updating || self.moreResultsQuery == nil) {
        return;
    }
    else {
        self.updating = YES;
    }
	self.moreResultsQuery.delegate = self;
	[self.moreResultsQuery refresh];
}

#pragma mark Public methods to be overridden

// Subclasses must override this to construct and return custom query objects with retain count 0 (autoreleased)
- (DTAsyncQueryOperation *)constructQueryOperation {
	DTAbstractMethod
    return [DTAsyncQueryOperation operationWithDelegate:self];
}

// Subclasses can override this to return detailed cursor data if there are more results available
- (NSDictionary *)cursorData {
	return [NSDictionary dictionary];
}

// Subclasses can implement this if they want to have indexes along the right side
- (NSArray *)groupIndexes {
    return nil;
}

// Subclasses can implement this if they want to have headers above each section
- (NSString *)titleForGroupWithIndex:(NSUInteger)index {
    return nil;
}

// Subclasses may override this and set the moreResultsQuery property if another page of results can be loaded after this one.
// If no more results can be lodaed, this method should set moreResultsQuery to nil.
- (void)loadMoreResultsQuery {
	self.moreResultsQuery = nil;
}

#pragma mark DTAsyncQueryOperationDelegate methods

- (void)operationWillStartLoading:(DTAsyncQueryOperation *)query {
	if ([delegate respondsToSelector:@selector(queryWillStartLoading:)]) {
		[delegate queryWillStartLoading:self];
	}
}

- (void)operationDidFinishLoading:(DTAsyncQueryOperation *)queryOperation {
    self.rawRows = queryOperation.rows;
    [self postProcessRawRows];
    self.loaded = YES;
	[self loadMoreResultsQuery];
    [delegate queryDidFinishLoading:self];
    self.updating = NO;
}

- (void)operationDidCancelLoading:(DTAsyncQueryOperation *)queryOperation {
	self.updating = NO;
	if ([delegate respondsToSelector:@selector(queryDidCancelLoading:)]) {
		[delegate performSelectorOnMainThread:@selector(queryDidCancelLoading:) withObject:self waitUntilDone:NO];
	}	
}

- (void)operationDidFailLoading:(DTAsyncQueryOperation *)queryOperation {
    self.error = [queryOperation error];
    [delegate queryDidFailLoading:self];
    self.updating = NO;
}

#pragma mark DTAsyncQueryDelegate methods

- (void)queryWillStartLoading:(DTAsyncQuery *)theMoreResultsQuery {
	if ([delegate respondsToSelector:@selector(queryWillStartLoadingMoreResults:)]) {
		[delegate queryWillStartLoadingMoreResults:self];
	}
}

- (void)queryDidFinishLoading:(DTAsyncQuery *)theMoreResultsQuery {
	[self.rows addObjectsFromArray:theMoreResultsQuery.rows];
	self.moreResultsQuery = theMoreResultsQuery.moreResultsQuery;
	self.updating = NO;
	if ([delegate respondsToSelector:@selector(queryDidFinishLoadingMoreResults:)]) {
		[delegate queryDidFinishLoadingMoreResults:self];
	}
}

- (void)queryDidCancelLoading:(DTAsyncQuery *)theMoreResultsQuery {
	self.updating = NO;
	if ([delegate respondsToSelector:@selector(queryDidCancelLoadingMoreResults:)]) {
		[delegate performSelectorOnMainThread:@selector(queryDidCancelLoadingMoreResults:) withObject:self waitUntilDone:NO];
	}
}

- (void)queryDidFailLoading:(DTAsyncQuery *)theMoreResultsQuery {
	self.error = self.moreResultsQuery.error;
	self.updating = NO;
	if ([delegate respondsToSelector:@selector(queryDidFailLoadingMoreResults:)]) {
		[delegate performSelectorOnMainThread:@selector(queryDidFailLoadingMoreResults:) withObject:self waitUntilDone:NO];
	}
}

#pragma mark NSFastEnumeration methods
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    return [rows countByEnumeratingWithState:state objects:stackbuf count:len];
}

#pragma mark Private methods

- (void)postProcessRawRows {
    [self transformRawRows];
    [self filterTransformedRows];
	[self sortRows];
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
    if (self.grouper) {
        [self.grouper groupRows:rows into:groups];
    }
}

- (void)sortRows {
	if (self.rowSorter) {
		self.rows = [self.rowSorter sortRows:self.rows];
	}
}

@end
