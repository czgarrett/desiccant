//
//  NSManagedObject+Zest.m
//  ProLog
//
//  Created by Christopher Garrett on 9/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#ifdef __IPHONE_3_0
#import "NSManagedObject+Zest.h"


@implementation NSManagedObject ( Zest )

- (NSString *) stringID {
   return [[[self objectID] URIRepresentation] absoluteString];
}

- (NSString *) urlParam {
   NSURL *url = [[self objectID] URIRepresentation];
   NSString *result =  [[[url absoluteString] substringFromIndex: 14] stringByReplacingOccurrencesOfString: @"/" withString: @"-"];
   return result;
}

@end

#endif