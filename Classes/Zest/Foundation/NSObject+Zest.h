//
//  NSObject+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Zest) 

@property (nonatomic, retain, readonly) NSString *to_s;
@property (nonatomic, assign, readonly) NSInteger to_i;
@property (nonatomic, retain, readonly) NSURL *to_url;
@property (nonatomic, retain, readonly) NSDate *to_date;

@end
