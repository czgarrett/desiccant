//
//  AbstractTest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "AbstractTest.h"


@implementation AbstractTest

-(NSString *)name
{
   if(name) {
      return name;
   } else {
      return [[self class] description];      
   }
}

-(NSInteger)count
{
   return 1;
}

-(void)runTestInOperation:(TestOperation *)operation
{
   // do nothing
}


@end
