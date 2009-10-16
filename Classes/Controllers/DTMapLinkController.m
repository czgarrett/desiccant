//
//  DTMapLinkController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTMapLinkController.h"
#import "MapKit/MapKit.h"
#import "RegexKitLite.h"


@interface DTMapLinkController()
- (CLLocationDegrees) latitudeFromURLString:(NSString *)urlString;
- (CLLocationDegrees) longitudeFromURLString:(NSString *)urlString;
- (CLLocationDegrees) spanHeightFromURLString:(NSString *)urlString;
- (CLLocationDegrees) spanWidthFromURLString:(NSString *)urlString;
- (NSString *) titleFromURLString:(NSString *)urlString;
- (NSString *) subtitleFromURLString:(NSString *)urlString;
@end

@implementation DTMapLinkController
@synthesize parentController;

- (void)dealloc {
    self.parentController = nil;
    
    [super dealloc];
}

- (id)initWithParentController:(UIViewController *)theParentController {
    if (self = [super init]) {
        self.parentController = theParentController;
    }
    return self;
}

+ (DTMapLinkController *)controllerWithParentController:(UIViewController *)theParentController{
    return [[[self alloc] initWithParentController:theParentController] autorelease];
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
    
    DTMapViewController *controller = [DTMapViewController controllerWithLatitude:latitude longitude:longitude spanHeight:spanHeight spanWidth:spanWidth];
    if (annotationTitle) {
        DTMapAnnotation *annotation = [DTMapAnnotation annotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:latitude longitude:longitude];
        [controller.mapView addAnnotation:annotation];
    }
    if (parentController.navigationController) {
        [parentController.navigationController pushViewController:controller animated:YES];
    }
    else {
        // TODO: Support usage without navigation controller by presenting modal
        NSAssert (0, @"Currently DTImageViewerLinkController requires its parent view controller to have a navigation controller.");
    }
    
    return NO;
}

- (CLLocationDegrees) latitudeFromURLString:(NSString *)urlString {
//    return [[urlString stringByMatching:@"app://map\\?.*ll=([^,]*),"] floatValue];
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
    return [[urlString stringByMatching:@"app://map\\?.*title=([^&]*)&?" capture:1L] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) subtitleFromURLString:(NSString *)urlString {
    return [[urlString stringByMatching:@"app://map\\?.*subtitle=([^&]*)&?" capture:1L] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
