//
//  TestOperationDelegate.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/13/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestSuite;
@class TestCase;
@class TestOperation;
@class AbstractTest;

@protocol TestOperationDelegate

- (void)testSuiteStarted:(TestSuite *)test;
- (void)testStarted:(AbstractTest *)test;
- (void)testPassed;
- (void)testFailed:(AbstractTest *)test;
- (void)allTestsPassed;

@end
