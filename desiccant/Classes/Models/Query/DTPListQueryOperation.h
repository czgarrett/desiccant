//
//  DTPListQueryOperation.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQueryOperation.h"

@interface DTPListQueryOperation : DTAsyncQueryOperation {
    NSString *fileName;
    NSArray *rows;
    NSString *error;
}

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain, readonly) NSArray *rows;
@property (nonatomic, retain, readonly) NSString *error;

- (id)initOperationWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryOperationDelegate> *)aDelegate;
+ (DTPListQueryOperation *)operationWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryOperationDelegate> *)aDelegate;

@end
