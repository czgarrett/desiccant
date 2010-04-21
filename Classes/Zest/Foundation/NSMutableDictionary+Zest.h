//
//  NSMutableDictionary+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

#define $MD(...) [NSMutableDictionary dictionaryWithKeysAndObjects: __VA_ARGS__, nil]

@interface NSMutableDictionary (Zest)

+ (NSMutableDictionary *) dictionaryFromResource: (NSString *) bundleFile;

- (void)setObjectUnlessNil: (id) anObject forKey: (id) key;
- (void)setString:(NSString *)string forMutableStringWithKey:(id)key;
- (void)clearMutableStringForKey:(id)key;

@end
