//
//  DTGeocoder.m
//  RedRover
//
//  Created by Christopher Garrett on 2/2/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTGeocoder.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "NSDictionary+Zest.h"
#import "CBucks.h"

NSString * const kStatusOk = @"OK";
NSString * const kStatusZeroResults = @"ZERO_RESULTS";
NSString * const kStatusOverQueryLimit = @"OVER_QUERY_LIMIT";
NSString * const kStatusRequestDenied = @"REQUEST_DENIED";
NSString * const kStatusInvalidRequest = @"INVALID_REQUEST";

@interface DTGeocoder ()

@property (nonatomic, copy) ArrayBlock completionBlock;
@property (nonatomic, copy) ErrorBlock failureBlock;

@end


@implementation DTGeocoder

@synthesize completionBlock, failureBlock;
@synthesize region;

// The results are an array of dictionaries corresponding to the JSON returned by Google API.
// See http://code.google.com/apis/maps/documentation/geocoding/
// This method retains the geocoder and autoreleases it on completion, so you are free to release
// a geocoder if you are using it within the scope of a method.
- (void) geocode: (NSString *) searchTerm completion: (ArrayBlock) completion failure: (ErrorBlock) onError {
   [self retain];
   self.completionBlock = completion;
   self.failureBlock = onError;

   NSString *parameter = [[searchTerm stringByReplacingOccurrencesOfString: @" " withString: @"+"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
   NSMutableString *urlString = [NSMutableString stringWithString: @"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&address="];
   [urlString appendString: parameter];
   if (self.region) [urlString appendFormat: @"&region=%@", self.region];
   NSURL *url = [NSURL URLWithString: urlString];
   NSLog(@"Search URL: %@", url);
   __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: url];
   request.requestMethod =  @"GET";
   [request setFailedBlock: ^{
      if (self.failureBlock) {
         self.failureBlock(request.error);
         self.failureBlock = nil;
      }
      [self autorelease];
   }];
   [request setCompletionBlock: ^{
      NSDictionary *jsonDict = [[request responseString] JSONValue];
      NSLog(@"Geocoder Results: %@", jsonDict);
      NSArray *results = [jsonDict objectForKey: @"results"];
      NSString *status = [jsonDict objectForKey: @"status"];
      if ([status isEqual: kStatusOk] || [status isEqual: kStatusZeroResults]) {
         self.completionBlock(results);
         self.completionBlock = nil;
      } else {
         NSError *error = [NSError errorWithDomain: @"DTGeocoder" 
                                              code: 2 
                                          userInfo: $D(NSLocalizedDescriptionKey, @"Sorry, the location lookup service is not currently available.")];
         self.failureBlock(error);
      }
      [self autorelease];
   }];
   [request startAsynchronous];
}

@end
