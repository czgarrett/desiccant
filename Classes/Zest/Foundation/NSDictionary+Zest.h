//
//  NSDictionary+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary(Zest)
- (NSString *)stringForKey:(id)key;
- (NSURL *)urlForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSDate *)dateForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSData *)dataForKey:(id)key;
- (BOOL)hasValueForKey:(id)key;
- (void)appendString:(NSString *)string toMutableStringWithKey:(id)key;
@end
