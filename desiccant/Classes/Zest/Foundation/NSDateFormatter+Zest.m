//
//  NSDateFormatter+Zest.m
//  desiccant
//
//  Created by Christopher Garrett on 4/21/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSDateFormatter+Zest.h"


@implementation NSDateFormatter (Zest)

- (NSString *) relativeDateString: (NSDate *) date {
   
   // NOTE I wrote this and never used it, but it should be useful.  Assume it has not been tested. - czg
   
   NSDate *now = [NSDate date];
   double time = [date timeIntervalSinceDate:now];
   time *= -1;
   if(time < 1) {
      return [self stringFromDate: date];
   } else if (time < 60) {
      return @"less than a minute ago";
   } else if (time < 3600) {
      int diff = round(time / 60);
      if (diff == 1) 
         return [NSString stringWithFormat:@"1 minute ago", diff];
      return [NSString stringWithFormat:@"%d minutes ago", diff];
   } else if (time < 86400) {
      int diff = round(time / 60 / 60);
      if (diff == 1)
         return [NSString stringWithFormat:@"1 hour ago", diff];
      return [NSString stringWithFormat:@"%d hours ago", diff];
   } else if (time < 604800) {
      int diff = round(time / 60 / 60 / 24);
      if (diff == 1) 
         return [NSString stringWithFormat:@"yesterday", diff];
      if (diff == 7) 
         return [NSString stringWithFormat:@"last week", diff];
      return[NSString stringWithFormat:@"%d days ago", diff];
   } else {
      int diff = round(time / 60 / 60 / 24 / 7);
      if (diff == 1)
         return [NSString stringWithFormat:@"last week", diff];
      return [NSString stringWithFormat:@"%d weeks ago", diff];
   }   
}

@end
