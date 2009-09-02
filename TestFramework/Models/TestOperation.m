//
//  TestOperation.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/13/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestOperation.h"
//#import "TestAssertionHandler.h"

@implementation TestOperation

@synthesize failureMessage;
@synthesize currentTest;
@synthesize delegate;

-(id)initWithRootTest:(TestSuite *)myRootTest delegate: (id <TestOperationDelegate>) myDelegate
{
   if (self = [super init]) {
      rootTestSuite = myRootTest;
      [rootTestSuite retain];
      delegate = myDelegate;
   }
   return self;
}

-(void)main
{
   NSLog(@"TestOperation main method");
   NSLog(@"Current assertion handler: %@", [NSAssertionHandler currentHandler]);
   NSMutableDictionary *threadAttributes = [[NSThread currentThread] threadDictionary];
   NSLog(@"Current thread keys: %@", [[threadAttributes allKeys] componentsJoinedByString: @", "]);
   [rootTestSuite runTestInOperation: self];
}

-(void)dealloc
{
   [rootTestSuite release];
   [super dealloc];
}



@end
