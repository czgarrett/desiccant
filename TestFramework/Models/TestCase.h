//
//  TestCase.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestCase.h"
#import "AbstractTest.h"
#import "TestSuite.h"
#import "Assertions.h"


@interface TestCase : AbstractTest {
   SEL selector;
}

/*
 * Returns an empty test suite by default.  Since there is no easy way to do reflection in the iPhone SDK, subclasses should override this
 * and add all of their selectors to the suite
 */
+(TestSuite *)defaultSuite;
+(TestCase *)testWithSelector:(SEL)mySelector name:(NSString *)name;

-(id)initWithSelector:(SEL)mySelector name:(NSString *)name;
-(void)setUp;
-(void)tearDown;
-(void)runTest;

@end
