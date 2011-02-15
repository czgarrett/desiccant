//
//  DTAsyncQueryOperationDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//


@class DTAsyncQueryOperation;

@protocol DTAsyncQueryOperationDelegate

- (void)operationWillStartLoading:(DTAsyncQueryOperation *)query;
- (void)operationDidFinishLoading:(DTAsyncQueryOperation *)query;
- (void)operationDidFailLoading:(DTAsyncQueryOperation *)query;
- (void)operationDidCancelLoading:(DTAsyncQueryOperation *)query;

@end

#import "DTAsyncQueryOperation.h"
