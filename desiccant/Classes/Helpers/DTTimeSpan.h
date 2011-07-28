//
//  DTTimeSpan.h
//  medaxion
//
//  Created by Garrett Christopher on 7/28/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTTimeSpan : NSObject

@property (nonatomic, retain) NSDate *start;
@property (nonatomic, retain) NSDate *end;
@property (nonatomic, readonly) NSTimeInterval interval;

// Returns a time span that begins at the five minute mark before date and ends at the five minute mark
// after date.  e.g. if date is 5:57, returns 5:55-6:00.
+ (DTTimeSpan *) timeSpanForFiveMinutesThatInclude: (NSDate *) date;

// Returns a time span that begins at the fifteen minute mark before date and ends at the fifteen minute mark
// after date.  e.g. if date is 5:57, returns 5:45-6:00.
+ (DTTimeSpan *) timeSpanForFifteenMinutesThatInclude: (NSDate *) date;

+ (DTTimeSpan *) timeSpanWithStart: (NSDate *) start end: (NSDate *) end;

- (BOOL) intersects: (DTTimeSpan *) other;
- (BOOL) includes: (NSDate *) date;

// Returns a new autoreleased time span object with the receiver's start and end times adjusted
// by the given interval
- (DTTimeSpan *) timeSpanByAddingTimeInterval: (NSTimeInterval) interval;

@end
