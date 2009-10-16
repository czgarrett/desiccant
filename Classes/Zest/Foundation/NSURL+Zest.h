//
//  NSURL+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 12/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSURL ( Zest )

@property (nonatomic, retain, readonly) NSURLRequest *to_request;

// Returns the file URL for the main bundle's resource path
+ (NSURL *)resourceURL;

// Tests for network reachability for this URL's host
- (BOOL)hostIsReachable;
- (NSData *) cachedData;
- (BOOL) isCached;
// Returns the URL path's file extension, if any, or an empty string if it doesn't have one.
- (NSString *)pathExtension;

@end
