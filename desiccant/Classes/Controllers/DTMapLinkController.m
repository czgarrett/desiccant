//
//  DTMapLinkController.m
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTMapLinkController.h"
#import "MapKit/MapKit.h"
#import "Zest.h"
#import "DTMapAnnotation.h"

@interface DTMapLinkController()
- (CLLocationDegrees) latitudeFromURLString:(NSString *)urlString;
- (CLLocationDegrees) longitudeFromURLString:(NSString *)urlString;
- (CLLocationDegrees) spanHeightFromURLString:(NSString *)urlString;
- (CLLocationDegrees) spanWidthFromURLString:(NSString *)urlString;
- (NSString *) titleFromURLString:(NSString *)urlString;
- (NSString *) subtitleFromURLString:(NSString *)urlString;
@end

@implementation DTMapLinkController
@synthesize delegate;

- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithDelegate:(id <DTMapLinkControllerDelegate>)theDelegate {
    if ((self = [super init])) {
        self.delegate = theDelegate;
    }
    return self;
}

+ (id)controllerWithDelegate:(id <DTMapLinkControllerDelegate>)theDelegate {
    return [[(DTMapLinkController *)[self alloc] initWithDelegate:theDelegate] autorelease];
}

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [[request.URL absoluteString] startsWith:@"app://map?"];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    CLLocationDegrees latitude = [self latitudeFromURLString:[[request URL] absoluteString]];
    CLLocationDegrees longitude = [self longitudeFromURLString:[[request URL] absoluteString]];
    CLLocationDegrees spanWidth = [self spanWidthFromURLString:[[request URL] absoluteString]];
    CLLocationDegrees spanHeight = [self spanHeightFromURLString:[[request URL] absoluteString]];
    NSString *annotationTitle = [self titleFromURLString:[[request URL] absoluteString]];
    NSString *annotationSubtitle = [self subtitleFromURLString:[[request URL] absoluteString]];
    
	DTMapViewController *controller;
	if ([delegate respondsToSelector:@selector(mapViewControllerWithLatitude:longitude:latitudeDelta:longitudeDelta:)]) {
		controller = [delegate mapViewControllerWithLatitude:latitude longitude:longitude latitudeDelta:spanHeight longitudeDelta:spanWidth];
	}
	else {
		controller = [DTMapViewController controllerWithLatitude:latitude longitude:longitude latitudeDelta:spanHeight longitudeDelta:spanWidth];
	}

    if (annotationTitle) {
		DTMapAnnotation *annotation;
		if ([delegate respondsToSelector:@selector(mapAnnotationWithTitle:subtitle:latitude:longitude:)]) {
			annotation = [delegate mapAnnotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:latitude longitude:longitude];
		}
		else {
			annotation = [DTMapAnnotation annotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:latitude longitude:longitude];
		}
		
		if ([delegate respondsToSelector:@selector(addAnnotation:toController:)]) {
			[delegate addAnnotation:annotation toController:controller];
		}
		else {
			[controller.mapView addAnnotation:annotation];			
		}
    }

    if ([delegate respondsToSelector:@selector(navigationController)] && [delegate navigationController]) {
        [[delegate navigationController] pushViewController:controller animated:YES];
    }
    else {
        // NOTE: Need to support usage without navigation controller by presenting modal
        NSAssert (0, @"Currently DTImageViewerLinkController requires its parent view controller to have a navigation controller.");
    }
    
    return NO;
}

- (CLLocationDegrees) latitudeFromURLString:(NSString *)urlString {
    NSString *s = [urlString stringByMatching:@"app://map\\?.*ll=([^,]*)," capture:1L];
    return [s floatValue];
}
                                             
- (CLLocationDegrees) longitudeFromURLString:(NSString *)urlString {
    return [[urlString stringByMatching:@"app://map\\?.*ll=[^,]*,([+-.\\d]+)" capture:1L] floatValue];
}

- (CLLocationDegrees) spanHeightFromURLString:(NSString *)urlString {
    return [[urlString stringByMatching:@"app://map\\?.*spn=([^,]*)," capture:1L] floatValue];
}

- (CLLocationDegrees) spanWidthFromURLString:(NSString *)urlString {
    return [[urlString stringByMatching:@"app://map\\?.*spn=[^,]*,([+-.\\d]+)" capture:1L] floatValue];
}

- (NSString *) titleFromURLString:(NSString *)urlString {
	NSString *titleParam = [urlString stringByMatching:@"app://map\\?.*title=([^&]*)&?" capture:1L];
	NSString *titleParamWithPlussesReplaced = [titleParam stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString *decodedString = [titleParamWithPlussesReplaced stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	unless (decodedString) { // Try Latin1
		decodedString = [titleParamWithPlussesReplaced stringByReplacingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
	}
	return decodedString;
}

- (NSString *) subtitleFromURLString:(NSString *)urlString {
	NSString *titleParam = [urlString stringByMatching:@"app://map\\?.*subtitle=([^&]*)&?" capture:1L];
	NSString *titleParamWithPlussesReplaced = [titleParam stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString *decodedString = [titleParamWithPlussesReplaced stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	unless (decodedString) { // Try Latin1
		decodedString = [titleParamWithPlussesReplaced stringByReplacingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
	}
	return decodedString;
}

@end
