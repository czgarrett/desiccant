//
//  DTAsyncQueryOperationDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTAsyncQueryOperation.h"

@protocol DTAsyncQueryOperationDelegate

- (void)operationWillStartLoading:(DTAsyncQueryOperation *)query;
- (void)operationDidFinishLoading:(DTAsyncQueryOperation *)query;
- (void)operationDidFailLoading:(DTAsyncQueryOperation *)query;

@end
