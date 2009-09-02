//
//  AbstractTest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestOperation;

@interface AbstractTest : NSObject {
   NSString *name;
}

-(void)runTestInOperation:(TestOperation *)operation;
-(NSString *)name;
-(NSInteger)count;


@end
