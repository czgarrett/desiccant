//
//  TestSuite.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTest.h"
#import "TestOperation.h"

#define AddTestCase(testSuite, selectorName) \
          TestCase *selectorName = [[[testSuite testCaseClass] alloc] initWithSelector: @selector(selectorName) name: [NSString stringWithUTF8String: #selectorName]]; \
          [testSuite addTest: selectorName];

@class TestCase;

@interface TestSuite : AbstractTest {
   NSMutableArray *tests;
   Class testCaseClass;
}

@property(nonatomic) Class testCaseClass;

+(TestSuite *)testSuiteForTestCaseClass:(Class) testCaseClass;
+(TestSuite *)testSuiteWithName:(NSString *)name;
-(id)initWithName:(NSString *)myName;
-(void)addTest:(AbstractTest *)test;
-(void)runTestInOperation: (TestOperation *)testOperation;
@end
