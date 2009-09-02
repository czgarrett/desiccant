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
}

@property (readonly) BOOL updating;
@property (nonatomic, retain) NSObject <DTAsyncQueryOperationDelegate> *delegate;

- (id)initWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate;
+ (DTAsyncQueryOperation *)operationWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate;

// Subclasses should override this to execute the query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery;
// If a query is successful, subclasses should return their query results when this is called
- (NSArray *)rows;
// If a query is unsuccessful, subclasses should return an appropriate error message when this is called.
- (NSString *)error;

@end

#import "DTAsyncQueryOperationDelegate.h"
