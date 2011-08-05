//
//  DTTimeSpan.m
//  medaxion
//
//  Created by Garrett Christopher on 7/28/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTTimeSpan.h"
#import "NSDate+Zest.h"

@implementation DTTimeSpan

@synthesize start, end;

+ (DTTimeSpan *) timeSpanForFiveMinutesThatInclude: (NSDate *) date {
   DTTimeSpan *result = [[[DTTimeSpan alloc] init] autorelease];
   result.start = [date dateAtPreviousFiveMinuteMark];
   result.end = [date dateAtNextFiveMinuteMark];
   return result;
}

+ (DTTimeSpan *) timeSpanForFifteenMinutesThatInclude: (NSDate *) date {
   DTTimeSpan *result = [[[DTTimeSpan alloc] init] autorelease];
   result.start = [date dateAtPreviousQuarterHour];
   result.end = [date dateAtNextQuarterHour];
   return result;
}

+ (DTTimeSpan *) timeSpanWithStart: (NSDate *) start end: (NSDate *) end {
   DTTimeSpan *result = [[[DTTimeSpan alloc] init] autorelease];
   result.start = start;
   result.end = end;
   return result;
}

- (DTTimeSpan *) timeSpanByAddingTimeInterval: (NSTimeInterval) interval {
   return [DTTimeSpan timeSpanWithStart: [self.start dateByAddingTimeInterval: interval] 
                                    end: [self.end dateByAddingTimeInterval: interval]];
}


- (NSTimeInterval) interval {
   if (start == nil || end == nil) return 0;
   return [end timeIntervalSinceDate: start];
}

- (BOOL) intersects:(DTTimeSpan *)other {
   if (self.start && self.end) {
      return ([other.start isEarlierThanDate: self.end] && [other.start isLaterThanDate: self.start]) ||
      ([other.end isEarlierThanDate: self.end] && [other.end isLaterThanDate: self.start]);
   } else if (self.start) { // Start but no end
      return [other.start isLaterThanDate: self.start] || (other.end && [other.end isLaterThanDate: self.start]);
   } else {
      return NO;
   }
}

- (BOOL) includes: (NSDate *)date  {
   if (date == nil) return NO;
   if (self.end && self.start) {
      return [self.start isEarlierThanDate: date] && [self.end isLaterThanDate: date];
   } else if (self.start) {
      return [self.start isEarlierThanDate: date];
   } else {
      return NO;
   }
}

@end
