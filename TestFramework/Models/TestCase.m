//
//  TestCase.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestCase.h"
#import "TestSuite.h"


@implementation TestCase 

+ (TestSuite *)defaultSuite
{
   return [TestSuite testSuiteWithName: [[self class] description]];
}

+ (TestCase *)testWithSelector: (SEL)mySelector name:(NSString *)name
{
   return [[[[self class] alloc] initWithSelector: mySelector name: name] alloc];
}

-(id)initWithSelector:(SEL)mySelector name:(NSString *)myName
{
   if (self = [super init]) {
      selector = mySelector;
      name = myName;
      [name retain];
   }
   return self;
}

-(void)dealloc
{
   [name release];
   [super dealloc];
}

-(void)setUp
{
   // do nothing by default;
}

-(void)tearDown
   {
      // do nothing by default
   }
-(void)runTest
   {
      NSLog(@"About to run test");
      [self performSelector: selector onThread: [NSThread currentThread] withObject:nil waitUntilDone: YES];
   }

-(void)runTestInOperation:(TestOperation *)operation
{
   [self runTest];
}

@end
