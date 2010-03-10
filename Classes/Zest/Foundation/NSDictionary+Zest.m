//
//  NSDictionary+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSDictionary+Zest.h"
#import "Zest.h"

@implementation NSDictionary(Zest)

+ (NSDictionary *) dictionaryWithResourceNamed: (NSString *) resourceName {
   return [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: resourceName ofType: @"plist"]];
}


- (NSString *)stringForKey:(id)key {
    return ((NSObject *)[self objectForKey:key]).to_s;
}

- (NSURL *)urlForKey:(id)key {
    return ((NSObject *)[self objectForKey:key]).to_url;
}

- (NSInteger)integerForKey:(id)key {
    return ((NSObject *)[self objectForKey:key]).to_i;
}

- (NSNumber *)numberForKey:(id)key {
    return (NSNumber *)[self objectForKey:key];
}

- (NSDate *)dateForKey:(id)key {
    return ((NSObject *)[self objectForKey:key]).to_date;
}

- (NSMutableString *)mutableStringForKey:(id)key {
    return (NSMutableString *)[self objectForKey:key];
}

- (NSArray *)arrayForKey:(id)key {
    return (NSArray *)[self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(id)key {
    return (NSDictionary *)[self objectForKey:key];
}

- (NSData *)dataForKey:(id)key {
    return (NSData *)[self objectForKey:key];
}

- (BOOL)hasValueForKey:(id)key {
    return [self objectForKey:key] != nil;
}

- (void)appendString:(NSString *)string toMutableStringWithKey:(id)key {
    [[self mutableStringForKey:key] appendString:string];
}


@end
