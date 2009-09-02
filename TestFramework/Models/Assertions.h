/*
 *  Assertions.h
 *  ZWorkbench
 *
 *  Created by Christopher Garrett on 6/16/08.
 *  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
 *
 */

#import "TestException.h"

#define WithinTolerance(difference, tolerance) (((difference) < (tolerance)) && ((difference) > (-tolerance)))

#define Assert(test, ...) \
  if (!(test)) { \
      NSString *reason = [NSString stringWithFormat: __VA_ARGS__ ]; \
      TestException *e = [TestException exceptionWithReason: reason];\
      @throw e; \
   } 

#define AssertEqualObjects(expected, actual, message) \
   Assert((expected) == (actual), @"Expected %@ but was %@. %@", expected, actual, message);

#define AssertEqualInts(expected, actual, message) \
Assert((expected) == (actual), @"Expected %d but was %d.  %@", expected, actual, message);

// We do the "if (YES)" thing because otherwise the variable will end up getting redefined in the code.
// Remember that macros are just pasting into the code.
#define AssertTimesClose(expected, actual, tolerance, message) \
   if (YES) { \
      NSTimeInterval time_interval = (([expected timeIntervalSince1970]) - ([actual timeIntervalSince1970])); \
      Assert(WithinTolerance(time_interval, tolerance), @"Expected time difference to be < %f but was %f. %@", tolerance, time_interval, message); \
   }

#define AssertFloatsClose(expected, actual, tolerance, message) \
   if (YES) { \
      double float_interval = (((double) expected) - ((double) actual)); \
      Assert(WithinTolerance(float_interval, tolerance), @"Expected difference to be < %f but was %f. %@", tolerance, float_interval, message); \
   }

