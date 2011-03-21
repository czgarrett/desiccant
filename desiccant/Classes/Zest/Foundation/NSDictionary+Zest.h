//
//  NSDictionary+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Zest)
// Returns a dictionary with a single key, "title", mapped to the specified titleValue.
+ (NSDictionary *)dictionaryWithTitle:(NSString *)titleValue;
// Returns a dictionary with specified values for the keys "title" and "subtitle".
+ (NSDictionary *)dictionaryWithTitle:(NSString *)titleValue subtitle:(NSString *)subtitleValue;
+ (NSDictionary *) dictionaryWithResourceNamed: (NSString *) resourceName;

- (id) objectForKey:(id)aKey ifNil: (id) substitute;
- (NSString *)stringForKey:(id)key;
- (NSURL *)urlForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (double)doubleForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (NSDate *)dateForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSMutableArray *)mutableArrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSMutableDictionary *)mutableDictionaryForKey:(id)key;
- (NSData *)dataForKey:(id)key;
- (BOOL)hasValueForKey:(id)key;
- (void)appendString:(NSString *)string toMutableStringWithKey:(id)key;
- (NSDictionary *)dictionaryWithLowercaseKeys;
- (NSString *)toQueryString;
// Returns the first key it can find.  Useful for a dictionary that has only one key.
- (id) anyKey;

@end
