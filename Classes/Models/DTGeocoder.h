//
//  DTGeocoder.h
//  RedRover
//
//  Created by Christopher Garrett on 2/2/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

// DTGeocoder uses the Google Geocoding API to perform a geocoding search.

#import <Foundation/Foundation.h>

typedef void(^ErrorBlock)(NSError *);
typedef void(^ArrayBlock)(NSArray *);

@interface DTGeocoder : NSObject {

}

// Optional Country code, e.g. "us" or "es"
@property(nonatomic, retain) NSString *region;

- (void) geocode: (NSString *) searchTerm completion: (ArrayBlock) onCompletion failure: (ErrorBlock) onError;


@end
