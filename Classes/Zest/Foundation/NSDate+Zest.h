//
//  NSDate+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate ( Zest ) 
+ (NSDate *)dateWithISO8601String:(NSString *)dateString;
- (NSString *)iso8601FormattedString;
- (NSString *)shortAgeString;
@end
