//
//  NSURL+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 12/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NSURL ( Zest )

@property (nonatomic, retain, readonly) NSURLRequest *to_request;

// Returns the file URL for the main bundle's resource path
+ (NSURL *)resourceURL;
+ (NSURL *)urlForDrivingDirectionsFrom:(CLLocation *)from forceTitle:(NSString *)forcedFromTitle to:(CLLocation *)to forceTitle:(NSString *)forcedToTitle;
+ (NSURL *)URLWithFormat: (NSString *) format, ...;

// Tests for network reachability for this URL's host
- (BOOL)hostIsReachable;
- (NSData *) cachedURLData;
- (BOOL) isCached;
// Returns the URL path's file extension, if any, or an empty string if it doesn't have one.
- (NSString *)pathExtension;
// Returns a dictionary containing the URL's decoded query parameters, if any
- (NSDictionary *)queryParameters;

@end

@interface FixCategoryBugNSURL : NSObject {}
@end
