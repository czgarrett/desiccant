//
//  NSDictionary+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSDictionary+Zest.h"
#import "NSString+Zest.h"
#import "NSObject+Zest.h"
#import "NSArray+Zest.h"

@implementation NSDictionary(Zest)

+ (NSDictionary *) dictionaryWithResourceNamed: (NSString *) resourceName {
   return [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: resourceName ofType: @"plist"]];
}


+ (NSDictionary *)dictionaryWithTitle:(NSString *)titleValue {
	return [NSDictionary dictionaryWithObject:titleValue forKey:@"title"];
}

+ (NSDictionary *)dictionaryWithTitle:(NSString *)titleValue subtitle:(NSString *)subtitleValue {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			titleValue, @"title",
			subtitleValue, @"subtitle",
			nil];
}

- (id) objectForKey:(id)aKey ifNil: (id) substitute {
   id result = [self objectForKey: aKey];
   return result == nil ? substitute : result;
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
    return ((NSObject *)[self objectForKey:key]).to_n;
}

- (double)doubleForKey:(id)key {
    return [[self numberForKey:key] doubleValue];
}

- (BOOL)boolForKey:(id)key {
	return [self integerForKey:key] == 1;
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

- (NSMutableArray *)mutableArrayForKey:(id)key {
    return (NSMutableArray *)[self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(id)key {
    return (NSDictionary *)[self objectForKey:key];
}

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key {
    return (NSMutableDictionary *)[self objectForKey:key];
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

- (NSDictionary *)dictionaryWithLowercaseKeys {
	NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithCapacity:[self count]];
	for (id key in self) {
		if ([key respondsToSelector:@selector(lowercaseString)]) {
			[newDictionary setObject:[self objectForKey:key] forKey:[key lowercaseString]];
		}
	}
	return newDictionary;
}

- (id) anyKey {
   return [[self allKeys] firstObject];
}


- (NSString *)toQueryString {
	NSMutableString *queryString = [NSMutableString stringWithCapacity:128];
	NSString *separator = @"";
	for (NSString *key in self) {
		[queryString appendString:separator];
		[queryString appendFormat:@"%@=%@", key, [[self stringForKey:key] stringByAddingPercentEscapesIncludingLegalCharactersUsingEncoding:NSUTF8StringEncoding]];
		separator = @"&";
	}
	return queryString;
}

@end


@interface FixCategoryBugNSDictionary : NSObject {}
@end
@implementation FixCategoryBugNSDictionary
@end
