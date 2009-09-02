/*
 *  ProgressDelegate.h
 *  ZWorkbench
 *
 *  Created by Christopher Garrett on 5/20/08.
 *  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
 *
 */



@protocol OperationProgressDelegate

- (void)operationUpdate:(NSOperation *)operation progress:(float)progress message:(NSString *)message;
- (void)operationComplete:(NSOperation *)operation;
- (void)operation:(NSOperation *)operation didFailWithError:(NSError *)error;

@end