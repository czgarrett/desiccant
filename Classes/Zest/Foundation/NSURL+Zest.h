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

// Tests for network reachability for this URL's host
- (BOOL)hostIsReachable;
- (NSData *) cachedData;
- (BOOL) isCached;

@end
