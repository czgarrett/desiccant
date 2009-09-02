//
//  TestSuite.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestSuite.h"
#import "TestException.h"

@implementation TestSuite

@synthesize testCaseClass;

+(TestSuite *)testSuiteWithName:(NSString *)name
{
   return [[[TestSuite alloc] initWithName: name] autorelease];
}

+(TestSuite *)testSuiteForTestCaseClass:(Class) theTestCaseClass
{
   TestSuite *result = [TestSuite testSuiteWithName: [theTestCaseClass description]];
   result.testCaseClass = theTestCaseClass;
   return result;
}

-(id)initWithName:(NSString *)myName
{
   if (self = [super init]) {
      name = myName;      
      [name retain];
      tests = [[NSMutableArray alloc] init];
   }
   return self;
}
-(void)dealloc
{
   [name release];
   [tests release];
   [super dealloc];
}
-(void)addTest:(AbstractTest *)test 
{
   [tests addObject: test];
}
-(void)runTestInOperation: (TestOperation *)testOperation
{
   id <TestOperationDelegate> delegate = [testOperation delegate];
   [(NSObject *)delegate performSelectorOnMainThread:@selector(testSuiteStarted:) withObject: self waitUntilDone: NO];
   NSEnumerator *testEnum = [tests objectEnumerator];
   AbstractTest *test = nil;
   while ((test = (AbstractTest *)[testEnum nextObject]) && !(testOperation.failureMessage) && !([testOperation isCancelled])) {
      [(NSObject *)delegate performSelectorOnMainThread:@selector(testStarted:) withObject: test waitUntilDone: NO];
      @try {
         [test runTestInOperation: testOperation];         
         [(NSObject *)delegate performSelectorOnMainThread:@selector(testPassed) withObject: nil waitUntilDone: NO];         
      } @catch (TestException *e) {
         testOperation.failureMessage = [e reason];
         [(NSObject *)delegate performSelectorOnMainThread:@selector(testFailed:) withObject: test waitUntilDone: NO];
      }
   }
   if (![testOperation failureMessage]) {
      [(NSObject *)delegate performSelectorOnMainThread:@selector(allTestsPassed) withObject: nil waitUntilDone: NO];      
   }
}

-(NSInteger)count
{
   NSInteger sum = 0;
   NSEnumerator *testEnumerator = [tests objectEnumerator];
   AbstractTest *test;
   while (test = (AbstractTest *)[testEnumerator nextObject]) {
      sum += [test count];
   }
   return sum;
}


@end
