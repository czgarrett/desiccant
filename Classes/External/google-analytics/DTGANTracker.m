//
//  DTGANTracker.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 8/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGANTracker.h"

#if !(TARGET_IPHONE_SIMULATOR)
#import "GANTracker.h"
#endif

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 40;

@implementation DTGANTracker

+ (void)initializeGoogleAnalyticsWithAccountID:(NSString *)accountID
{
#if !(TARGET_IPHONE_SIMULATOR)
    [[GANTracker sharedTracker] startTrackerWithAccountID:accountID dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
#endif
}

+ (void)stopTracker
{
#if !(TARGET_IPHONE_SIMULATOR)
	[[GANTracker sharedTracker] stopTracker];
#endif
}

+ (void)trackPageView:(NSString *)path
{
#if !(TARGET_IPHONE_SIMULATOR)
	NSError *error;
	if (![[GANTracker sharedTracker] trackPageview:path withError:&amp;error])
	{
		// Handler error there
	}
#endif
}

+ (void)trackEvent:(NSString *)event action:(NSString *)action label:(NSString *)label
{
#if !(TARGET_IPHONE_SIMULATOR)
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:event action:action label:label value:0 withError:&amp;error])
	{
		// Handler error there
	}
#endif
}

@end