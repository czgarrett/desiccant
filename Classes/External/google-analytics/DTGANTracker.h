//
//  DTGANTracker.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 8/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DTGANTracker : NSObject
{
}

+ (void)initializeGoogleAnalyticsWithAccountID:(NSString *)accountID;
+ (void)stopTracker;
+ (void)trackPageView:(NSString *)path;
+ (void)trackEvent:(NSString *)event action:(NSString *)action label:(NSString *)label;

@end
