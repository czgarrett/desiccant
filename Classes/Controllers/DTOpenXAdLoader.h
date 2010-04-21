//
//  DTOpenXAdLoader.h
//  InsuranceJournal
//
//  Created by Curtis Duhn on 4/21/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zest.h"
#import "DTAdViewController.h"

@interface DTOpenXAdLoader : NSObject <DTAdLoader, DTAsyncQueryDelegate, DTImageViewDelegate> {
	UIView *placeholderView;
	NSObject <DTAdLoaderDelegate> *delegate;
	NSString *source;
	DTXMLRPCQuery *query;
	NSURL *url;
	NSInteger zoneNumber; // 45
	NSURLConnection *adLoggingConnection;
	DTImageView *adView;
}

@property (nonatomic, retain) IBOutlet UIView *placeholderView;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) DTXMLRPCQuery *query;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) NSInteger zoneNumber;

- (id)initWithPlaceholderView:(UIView *)thePlaceholderView url:(NSURL *)theXMLRPCURL source:(NSString *)theSource zoneNumber:(NSInteger)theZoneNumber;
+ (id)loaderWithPlaceholderView:(UIView *)thePlaceholderView url:(NSURL *)theXMLRPCURL source:(NSString *)theSource zoneNumber:(NSInteger)theZoneNumber;

@end
