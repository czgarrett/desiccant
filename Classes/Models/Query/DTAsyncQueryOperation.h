//
//  ACAsyncQueryOperation.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTAsyncQueryOperationDelegate;

@interface DTAsyncQueryOperation : NSOperation {
    BOOL updating;
    NSObject <DTAsyncQueryOperationDelegate> *delegate;
	BOOL executing;
	BOOL finished;
}

@property (readonly) BOOL updating;
@property (nonatomic, retain) NSObject <DTAsyncQueryOperationDelegate> *delegate;

- (id)initWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate;
+ (DTAsyncQueryOperation *)operationWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate;

// Subclasses should override this to execute a non-concurrent (blocking) query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery;

// Subclasses should override this to start a concurrent (non-blocking) query.  You must also:
//  1. Override isConcurrent and return YES.
//  2. Call -completeOperationWithError: once the query finishes or is aborted due to cancel or error.
- (void)startQuery;

// This method should only be called by subclasses on themselves.  It should not be called from other classes.
// Subclasses that implement concurrent queries should call this when the query finishes or is aborted due to error
// or cancellation.  Call -isCancelled periodically to see if the operation has been cancelled.  Call this with NO if the 
// operation was cancelled or successful.  Call this with YES if an error occurred.
- (void)completeOperationWithError:(BOOL)hadError;

// If a query is successful, subclasses should return their query results when this is called
- (NSArray *)rows;
// If a query is unsuccessful, subclasses should return an appropriate error message when this is called.
- (NSString *)error;

@end

#import "DTAsyncQueryOperationDelegate.h"
