//
//  DTAnalytics.m
//  WordTower
//
//  Created by Christopher Garrett on 5/13/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#ifdef USE_GOOGLE_ANALYTICS  // Define this in your project if you want to use this class

#import "DTAnalytics.h"
#if !TARGET_IPHONE_SIMULATOR
#import "GANTracker.h"
#endif

static DTAnalytics *sharedInstance;

@implementation DTAnalytics

+ (DTAnalytics *) sharedInstance {
   if (!sharedInstance) {
      sharedInstance = [[DTAnalytics alloc] init];
#if !TARGET_IPHONE_SIMULATOR
      [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-361070-8"
                                             dispatchPeriod: 10
                                                   delegate: sharedInstance];
#endif
   }
   return sharedInstance;
}

+ (void) resetInstance {
   if (sharedInstance) {
      [sharedInstance release];
      sharedInstance = nil;      
   }
}

+ (void) track: (NSString *) name {
   [[self sharedInstance] track: name];
}

- (void) track: (NSString *) name {
#if !TARGET_IPHONE_SIMULATOR
   NSError *error;
   if (![[GANTracker sharedTracker] trackPageview: name
                                        withError:&error]) {
      NSLog(@"Tracking error: %@", error);
   }   
#endif
}

#pragma mark GANTrackerDelegate methods

#if !TARGET_IPHONE_SIMULATOR
- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)eventsDispatched
              eventsFailedDispatch:(NSUInteger)eventsFailedDispatch {
}
#endif

@end

#endif