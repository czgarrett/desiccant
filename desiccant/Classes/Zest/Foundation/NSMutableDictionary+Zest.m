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

- (void) setObjectUnlessNil: (id) anObject forKey: (id) key {
   if (anObject != nil) {
      [self setObject: anObject forKey: key];
   }
}


+ (NSMutableDictionary *) dictionaryFromResource: (NSString *) bundleFile {
   NSMutableDictionary *result = nil;
   NSString *path = [[NSBundle mainBundle] pathForResource: bundleFile ofType:@"plist"];
   NSData *plistData = [NSData dataWithContentsOfFile:path];
   NSString *error;
   NSPropertyListFormat format;
   result = (NSMutableDictionary *) [NSPropertyListSerialization propertyListFromData:plistData
                                                                     mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                               format:&format
                                                                     errorDescription: &error];
   return result;
}


@end


@interface FixCategoryBugNSMutableDictionary : NSObject {}
@end
@implementation FixCategoryBugNSMutableDictionary
@end