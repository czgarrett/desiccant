//
//  DTTimeSpan.h
//  medaxion
//
//  Created by Garrett Christopher on 7/28/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

// Note:  A Time Span with nil end is considered to have an end far in the future.  

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
+ (DTTimeSpan *) timeSpanWithStart: (NSDate *) start length: (NSTimeInterval) length;

// Returns YES if the start time or end time of other is in the range of the receiver.
// If the receiver has a nil end, then returns YES if the start or end time of other occurs after the
// start time of the receiver.
- (BOOL) intersects: (DTTimeSpan *) other;

// Returns YES if the given date is between the receiver's start and end times.  If the receiver's end time is nil,
// returns YES if the given date comes after the receiver's start date.
- (BOOL) includes: (NSDate *) date;

// Returns time interval in the format 12d 4h 23m 23.243s
- (NSString *) timeIntervalString;


// Returns a new autoreleased time span object with the receiver's start and end times adjusted
// by the given interval
- (DTTimeSpan *) timeSpanByAddingTimeInterval: (NSTimeInterval) interval;

@end
