//
//  String+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSString+Zest.h"


@implementation NSString ( Zest )

- (NSString *) to_s {
    return self;
}

- (NSInteger) to_i {
    return [self integerValue];
}

- (NSURL *) to_url {
    return [NSURL URLWithString:self];
}

- (NSDate *) to_date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    NSDate *date = [dateFormatter dateFromString:self];
    // if (date == nil) { } - uncomment this if you want to handle failures
    [dateFormatter release];

    return date;
}

- (NSString *) HTMLUnencode {
   NSString *result;
   result = [self stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"];
   result = [result stringByReplacingOccurrencesOfString: @"&gt;" withString: @">"];
   result = [result stringByReplacingOccurrencesOfString: @"&nbsp;" withString: @" "];
   return result;
}

- (NSString *) stringTruncatedToLength: (NSInteger)length {
   if ([self length] > length) {
      return [NSString stringWithFormat: @"%@…", [self substringToIndex: length - 1]];
   } else {
      return [[self copy] autorelease];
   }
}

- (BOOL) empty {
   return [self length] == 0;
}

@end
