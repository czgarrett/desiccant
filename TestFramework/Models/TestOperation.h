//
//  TestOperation.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/13/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestOperationDelegate.h"
#import "AbstractTest.h"

@interface TestOperation : NSOperation {
   TestSuite *rootTestSuite;
   AbstractTest *currentTest;
   NSString *failureMessage;
   NSInteger totalCount;
   NSInteger completed;
   id <TestOperationDelegate>delegate;
}

@property(nonatomic, retain) AbstractTest *currentTest;
@property(nonatomic, retain) id <TestOperationDelegate> delegate;
@property(nonatomic, retain) NSString *failureMessage;

-(id)initWithRootTest:(TestSuite *)rootTest delegate: (id <TestOperationDelegate>) delegate;

@end
