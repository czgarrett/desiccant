//
//  DTAnalytics.h
//  WordTower
//
//  Created by Christopher Garrett on 5/13/10.
//  Copyright 2010 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_IPHONE_SIMULATOR
@interface DTAnalytics : NSObject {
}
#else
@interface DTAnalytics : NSObject <GANTrackerDelegate> {
}
#endif

+ (void) track: (NSString *) name;
- (void) track: (NSString *) name;
+ (DTAnalytics *) sharedInstance;
+ (void) resetInstance;

@end
