//
//  DTOpenXAdLoader.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTOpenXAdLoader.h"
#import "CBucks.h"


@interface DTOpenXAdLoader()
- (void)logAdImpression;
- (void)handleAdClick;
@property (nonatomic, retain) NSURLConnection *adLoggingConnection;
@property (nonatomic, retain) DTImageView *adView;
@end

@implementation DTOpenXAdLoader
@synthesize placeholderView, delegate, url, source, query, zoneNumber, adLoggingConnection, adView;

#pragma mark Memory management

- (void)dealloc {
	self.placeholderView = nil;
	self.delegate = nil;
	self.url = nil;
	self.source = nil;
	self.query.delegate = nil;
	self.query = nil;
	self.adLoggingConnection = nil;
	self.adView = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithPlaceholderView:(UIView *)thePlaceholderView url:(NSURL *)theXMLRPCURL source:(NSString *)theSource zoneNumber:(NSInteger)theZoneNumber {
	if ((self = [super init])) {
		self.placeholderView = thePlaceholderView;
		self.url = theXMLRPCURL;
		self.source = theSource;
		self.zoneNumber = theZoneNumber;
	}
	return self;
}

+ (id)loaderWithPlaceholderView:(UIView *)thePlaceholderView url:(NSURL *)theXMLRPCURL source:(NSString *)theSource zoneNumber:(NSInteger)theZoneNumber {
	return [[[self alloc] initWithPlaceholderView:thePlaceholderView url:theXMLRPCURL source:theSource zoneNumber:theZoneNumber] autorelease];
}

#pragma mark Public methods

#pragma mark DTAdLoader methods

// Loader must start loading an ad when this is called, and call the delegate's
// adLoader:didFinishLoadingView:withAdData: when the ad is ready.
- (void)loadAdForViewController:(DTAdViewController *)controller {
	if (!adView.image) {
		if (!self.source) self.source = @"";
		self.query = [DTXMLRPCQuery queryWithURL:self.url
										delegate:self 
									  methodName:@"openads.view" 
										  params:[NSArray arrayWithObjects:
												  [NSDictionary dictionaryWithObjectsAndKeys:@"0.0.0.0", @"remote_addr", [NSDictionary dictionary], @"cookies", nil], 
												  $S(@"zone:%d", self.zoneNumber), 
												  [NSNumber numberWithInt:0], 
												  @"", 
												  self.source, 
												  [NSNumber numberWithBool:NO], 
												  [NSArray array], 
												  nil]];
		[query refresh];
	}
	else {
		[delegate adLoader:self didFinishLoadingView:adView withAdData:nil];
		[self logAdImpression];
	}
}

// When this is called, the loader should cancel any ads that are loading for 
// the specified controller, and should not call 
// adLoader:didFinishLoadingView:withAdData:.
- (void)cancelLoadingAdForController:(DTAdViewController *)controller {
	self.query.delegate = nil;
	[self.query cancel];
}

// Return a placeholder view to present in place of the ad while the ad is loading.
// Return nil if you don't want to use a placeholder view, in which case, the
// adViewController's viewController will fill the whole screen until the ad is
// loaded and presented.  If not implemented, or if it returns nil,
// no placeholder will be displayed.
- (UIView *)placeholderViewForAdViewController:(DTAdViewController *)controller {
	return self.placeholderView;
}

// Called when the placeholder is displayed.  Loader may use this opportunity to notify
// the ad server that the placeholder was displayed.
- (void)registerPlaceholderWasDisplayedForViewController:(DTAdViewController *)controller {
}

// Called when the ad is displayed.  Loader may use this opportunity to notify
// the ad server that the ad was displayed.
- (void)registerAdWasDisplayedForViewController:(DTAdViewController *)controller withAdData:(NSObject *)theAdData {
	[self logAdImpression];
}

// Called when the placeholder was clicked. Loader may use this opportunity to
// notify the ad server that the placeholder was clicked and/or may load a view or
// web site in response to the click.
- (void)registerPlaceholderWasClickedForViewController:(DTAdViewController *)controller {
}

// Called when the ad was clicked. Loader may use this opportunity to
// notify the ad server that the ad was clicked and/or may load a view or
// web site in response to the click.
- (void)registerAdWasClickedForViewController:(DTAdViewController *)controller withAdData:(NSObject *)theAdData {
	[self handleAdClick];
}

#pragma mark DTAsyncQueryDelegate methods

- (void)queryWillStartLoading:(DTAsyncQuery *)theQuery {
}

- (void)queryDidFailLoading:(DTAsyncQuery *)theQuery {
    DTLog(@"Ad query failed loading with error: %@", theQuery.error);
}

- (void)queryDidFinishLoading:(DTAsyncQuery *)theQuery {
    if (!query.faultCode) {
		NSURL *bannerContentURL = [query.dictionaryResponse stringForKey:@"bannerContent"].to_url;
		if (bannerContentURL) {
			adView.delegate = nil;
			[self.adView = [[DTImageView alloc] initWithFrame:CGRectZero] release];
			adView.delegate = self;
			[self.adView loadFromURL:bannerContentURL];
		}
		else {
			DTLog(@"Response from ad server didn't contain a bannerContent URL");
		}
    }
    else {
        DTLog(@"*** XML-RPC Fault: \"%@\"", query.faultString);
    }
}

#pragma mark DTImageViewDelegate methods

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error {
	DTLog(@"Ad image failed loading with error: %@", error.description);
}

- (void)imageViewDidFinishLoading:(DTImageView *)imageView {
	if (adView.image) {
		adView.frame = CGRectMake(0.0f, 0.0f, adView.image.size.width, adView.image.size.height);
		[delegate adLoader:self didFinishLoadingView:adView withAdData:nil];
		[self logAdImpression];
	}
}


#pragma mark Private methods

- (void)logAdImpression {
    NSURL *impressionURL = [query.dictionaryResponse stringForKey:@"logUrl"].to_url;
    if (impressionURL) {
        NSMutableURLRequest *logUrlRequest = [NSMutableURLRequest requestWithURL:impressionURL];
        if (logUrlRequest) {
            [logUrlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
            self.adLoggingConnection = [NSURLConnection connectionWithRequest:logUrlRequest delegate:nil];
        }
        else {
            NSAssert (0, @"Failed to create logUrl request object.");
        }
    }
    else {
        DTLog(@"Didn't get a logUrl in the response from the ad server.");
    }
}

- (void)handleAdClick {
    NSURL *clickURL = [query.dictionaryResponse stringForKey:@"clickUrl"].to_url;
    if (clickURL) {
        [[UIApplication sharedApplication] openURL:clickURL];
    }
}

@end
