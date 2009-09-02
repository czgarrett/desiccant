//
//  NSURL+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 12/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import <SystemConfiguration/SCNetworkReachability.h>
#import "NSURL+Zest.h"

@interface NSURL ( Zest_private )
- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags;
@end
@implementation NSURL ( Zest_private )
- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags
{
    // kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
    // be reached using the current network configuration.
    BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
    
    // This flag indicates that the specified nodename or address can
    // be reached using the current network configuration, but a
    // connection must first be established.
    //
    // If the flag is false, we don't have a connection. But because CFNetwork
    // automatically attempts to bring up a WWAN connection, if the WWAN reachability
    // flag is present, a connection is not required.
    BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        noConnectionRequired = YES;
    }
    
    return (isReachable && noConnectionRequired) ? YES : NO;
}
@end


@implementation NSURL ( Zest )

- (NSString *) to_s {
    return [self absoluteString];
}

- (NSURL *) to_url {
    return self;
}

- (BOOL)hostIsReachable {
	if (![self host] || ![[self host] length]) {
        return NO;
    }
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [[self host] UTF8String]);
    BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    
    CFRelease(reachability);
    
    if (!gotFlags) {
        return NO;
    }
    
    return [self isReachableWithoutRequiringConnection:flags];
}

- (NSURLRequest *) to_request {
    return [NSURLRequest requestWithURL:self];
}

- (BOOL) isCached {
    return [self cachedData] != nil;
}

- (NSData *) cachedData {
    return [[[NSURLCache sharedURLCache] cachedResponseForRequest:self.to_request] data];
}

@end
