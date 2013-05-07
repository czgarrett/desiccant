//
//  DTTimeSpan.m
//  medaxion
//
//  Created by Garrett Christopher on 7/28/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTTimeSpan.h"
#import "NSDate+Zest.h"
#import "CBucks.h"

@implementation DTTimeSpan

+ (DTTimeSpan *) timeSpanForFiveMinutesThatInclude: (NSDate *) date {
   DTTimeSpan *result = [[DTTimeSpan alloc] init];
   result.start = [date dateAtPreviousFiveMinuteMark];
   result.end = [date dateAtNextFiveMinuteMark];
   return result;
}

+ (DTTimeSpan *) timeSpanForFifteenMinutesThatInclude: (NSDate *) date {
   DTTimeSpan *result = [[DTTimeSpan alloc] init];
   result.start = [date dateAtPreviousQuarterHour];
   result.end = [date dateAtNextQuarterHour];
   return result;
}

+ (DTTimeSpan *) timeSpanWithStart: (NSDate *) start end: (NSDate *) end {
   DTTimeSpan *result = [[DTTimeSpan alloc] init];
   result.start = start;
   result.end = end;
   return result;
}

+ (DTTimeSpan *) timeSpanWithStart: (NSDate *) start length: (NSTimeInterval) length {
   return [DTTimeSpan timeSpanWithStart: start end: [start dateByAddingTimeInterval: length]];
}


- (DTTimeSpan *) timeSpanByAddingTimeInterval: (NSTimeInterval) interval {
   return [DTTimeSpan timeSpanWithStart: [self.start dateByAddingTimeInterval: interval] 
                                    end: [self.end dateByAddingTimeInterval: interval]];
}

- (NSString *) description {
   return $S(@"%@ - %@: %@", self.start, self.end, [self timeIntervalString]);
}

- (NSString *) timeIntervalString {
   NSTimeInterval interval = self.interval;
   int days = (int) (interval/(60*60*24));
   int hours = ((int) (interval/(60*60))) % 24;
   int minutes = ((int) (interval/(60))) % 60;
   float seconds = interval - 60*((int) (interval/(60))); 
   return $S(@"%dd %dh %dm %fs", days, hours, minutes, seconds);
}


- (NSTimeInterval) interval {
   if (_start == nil || _end == nil) return 0;
   return [_end timeIntervalSinceDate: _start];
}

- (BOOL) intersects:(DTTimeSpan *)other {
   if (self.start && self.end) {
       return [self includes: other.start] || [self includes: other.end] || [other includes: self.start] || [other includes: self.end];
   } else if (self.start) { // Start but no end
      return [other.start isLaterThanOrEqualToDate: self.start] || (other.end && [other.end isLaterThanOrEqualToDate: self.start]);
   } else {
      return NO;
   }
}

- (BOOL) includes: (NSDate *)date  {
   if (date == nil) return NO;
   if (self.end && self.start) {
      return ([self.start isEarlierThanOrEqualToDate: date] && [self.end isLaterThanOrEqualToDate: date]) && ![self.end isEqualToDate: date];
   } else if (self.start) {
      return [self.start isEarlierThanOrEqualToDate: date] || [self.start isEqualToDate: date];
   } else {
      return NO;
   }
}

- (BOOL) startsInFuture {
   return [self.start isLaterThanNow];
}

- (BOOL) startsLaterThanTimeIntervalFromNow: (NSTimeInterval) interval {
    return [[self.start dateByAddingTimeInterval: -interval] isLaterThanNow];
}


- (id) copyWithZone:(NSZone *)zone {
    return [DTTimeSpan timeSpanWithStart: self.start end: self.end];
}

@end
