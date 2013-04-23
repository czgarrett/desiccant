//
//  NSURL+Zest.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 12/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import <SystemConfiguration/SCNetworkReachability.h>
#import "NSURL+Zest.h"
#import "NSString+Zest.h"
#import "NSArray+Zest.h"

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

+ (NSURL *)resourceURL {
    return [NSURL fileURLWithPath:[NSString resourcePath]];
}

+ (NSURL *)urlForDrivingDirectionsFrom:(CLLocation *)from forceTitle:(NSString *)forcedFromTitle to:(CLLocation *)to forceTitle:(NSString *)forcedToTitle {
	if (!to) return nil;
	NSMutableString *urlString = [NSMutableString stringWithString:@"http://maps.google.com/maps"];
	NSString *nextDelimiter = @"?";
	
	if (from) {
		[urlString appendFormat:@"%@saddr=%1.6f,%1.6f",
		 nextDelimiter,
		 from.coordinate.latitude, 
		 from.coordinate.longitude];
		if (forcedFromTitle) {
			[urlString appendFormat:@"+(%@)", 
			 [forcedFromTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
		nextDelimiter = @"&";
	}
	
	if (to) {
		[urlString appendFormat:@"%@daddr=%1.6f,%1.6f",
		 nextDelimiter,
		 to.coordinate.latitude, 
		 to.coordinate.longitude];
		if (forcedToTitle) {
			[urlString appendFormat:@"+(%@)", 
			 [forcedToTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	return [NSURL URLWithString:urlString];
}

+(NSURL *) URLWithFormat: (NSString *) format, ... {
   va_list args;
   va_start(args, format);          // Start scanning for arguments after firstObject.
   NSString *urlString = [[NSString alloc] initWithFormat: format arguments: args];
   return [NSURL URLWithString: urlString];
}


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
   NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest: self.to_request];
   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[response response];
   if ([httpResponse statusCode] >= 300 && [httpResponse statusCode] < 400) {
      NSURL *redirectURL = [NSURL URLWithString: [[httpResponse allHeaderFields] objectForKey: @"Location"]];
      return [redirectURL cachedData];
   } else {
      return [response data];
   }
}

- (NSString *)pathExtension {
    return [[self path] pathExtension];
}

- (NSDictionary *)queryParameters {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:16];
	if ([self query]) {
		NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
		for (NSString *pairString in pairs) {
			NSArray *pair = [pairString componentsSeparatedByString:@"="];
			if ([pair count] != 2) NSAssert (0, @"Found more than one equals sign in a parameter assignment");
			else {
				NSString *key = [[pair stringAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSString *value = [[pair stringAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				[params setObject:value forKey:key];
			}
		}
	}
	return params;
}

@end

@implementation FixCategoryBugNSURL
@end