//
//  NSMutableDictionary+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "NSMutableDictionary+Zest.h"


@implementation NSMutableDictionary (Zest)
- (void)clearMutableStringForKey:(id)key {
    [self setString:@"" forMutableStringWithKey:key];
}

- (void)setString:(NSString *)string forMutableStringWithKey:(id)key {
    [self setObject:[NSMutableString stringWithString:string] forKey:key];
}
@end
