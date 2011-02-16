//
//  NSString+ZestTests.m
//  desiccant
//
//  Created by Christopher Garrett on 2/15/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSString+ZestTests.h"
#import "NSString+Zest.h"
#import "NSArray+Zest.h"

@implementation NSString_ZestTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testContainsRegex {
   STAssertTrue([@"foobar" containsRegex: @"foo"], @"Should contain the regex foo" );
   STAssertTrue(![@"foobar" containsRegex: @"fu"], @"Should not contain the regex fu" );
//                  - (NSString *) stringByReplacingOccurrencesOfRegex: (NSString *) regexString withString: (NSString *) replacement;

}

- (void) testStringByReplacingOccurrencesOfRegexWithString {
   STAssertEqualObjects([@"foobarfoo" stringByReplacingOccurrencesOfRegex: @"foo" withString: @"bar"], @"barbarbar", @"Should be barbarbar" );
   STAssertEqualObjects([@"foobarfoo" stringByReplacingOccurrencesOfRegex: @"fu" withString: @"bar"], @"foobarfoo", @"Should be foobarfoo" );
}

- (void)testComponentsMatchedByRegex {
   STAssertEqualObjects([@"foobarfoo" componentsMatchedByRegex: @"foo"], $A(@"foo", @"foo"), @"Should contain the regex foo" );
   STAssertEqualObjects([@"foobar" componentsMatchedByRegex: @"fu"], $A(nil), @"Should not contain the regex fu" );
}

- (void)testStringByMatchingCapture {
   STAssertEqualObjects([@"foobar" stringByMatching: @"foo" capture: 0], @"foo", @"Should match foo");
   STAssertNil([@"foobar" stringByMatching: @"fu" capture: 0], @"Should be nil for fu");
}
               
                  

#endif

@end
