//
//  NSDate+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSDate+Zest.h"
#import "ISO8601DateFormatter.h"

@implementation NSDate ( Zest )

+ (NSDate *)dateWithISO8601String:(NSString *)dateString {
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSDate *date = [formatter dateFromString:dateString];
    [formatter release];
    return date;
}

- (NSString *)iso8601FormattedString {
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSString *string = [formatter stringFromDate:self];
    [formatter release];
    return string;    
}

- (NSDate *)to_date {
    return self;
}

- (NSString *)shortAgeString {
    NSTimeInterval age = -[self timeIntervalSinceNow];
    
    if (age / 60 / 60 / 24 < -365) return [NSString stringWithFormat:@"%dy", (int) age / 60 / 60 / 24 / 365];
    else if (age / 60 / 60 / 24 < -7) return [NSString stringWithFormat:@"%dw", (int) age / 60 / 60 / 24 / 7];
    else if (age / 60 / 60 < -24) return [NSString stringWithFormat:@"%dd", (int) age / 60 / 60 / 24];
    else if (age / 60 < -60) return [NSString stringWithFormat:@"%dh", (int) age / 60 / 60];
    else if (age < -60) return [NSString stringWithFormat:@"%dm", (int) age / 60];
    else if (age < 60) return [NSString stringWithFormat:@"%ds", (int) age];
    else if (age / 60 < 60) return [NSString stringWithFormat:@"%dm", (int) age / 60];
    else if (age / 60 / 60 < 24) return [NSString stringWithFormat:@"%dh", (int) age / 60 / 60];
    else if (age / 60 / 60 / 24 < 7) return [NSString stringWithFormat:@"%dd", (int) age / 60 / 60 / 24];
    else if (age / 60 / 60 / 24 < 365) return [NSString stringWithFormat:@"%dw", (int) age / 60 / 60 / 24 / 7];
    else return [NSString stringWithFormat:@"%dy", (int) age / 60 / 60 / 24 / 365];
}

@end
