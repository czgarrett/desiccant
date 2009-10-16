//
//  DTMapViewController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTMapViewController.h"


@interface DTMapViewController()
@end

@implementation DTMapViewController
@synthesize latitude, longitude, spanHeight, spanWidth;

- (void)dealloc {
    self.mapView = nil;

    [super dealloc];
}

- (id) initWithLatitude:(CLLocationDegrees)theLatitude 
              longitude:(CLLocationDegrees)theLongitude 
             spanHeight:(CLLocationDegrees)theSpanHeight 
              spanWidth:(CLLocationDegrees)theSpanWidth {
    if (self = [super init]) {
        self.latitude = theLatitude;
        self.longitude = theLongitude;
        self.spanHeight = theSpanHeight;
        self.spanWidth = theSpanWidth;
    }
    return self;
}

- (void) loadView {
    self.view = [[[MKMapView alloc] initWithFrame:CGRectZero] autorelease];
    self.mapView.mapType = MKMapTypeHybrid;
}

- (MKMapView *) mapView {
    return (MKMapView *) self.view;
}

- (void)setMapView:(MKMapView *)theView {
    self.view = theView;
}

+ (DTMapViewController *) controllerWithLatitude:(CLLocationDegrees)theLatitude 
                                       longitude:(CLLocationDegrees)theLongitude 
                                      spanHeight:(CLLocationDegrees)theSpanHeight 
                                       spanWidth:(CLLocationDegrees)theSpanWidth; {
    return [[[self alloc] initWithLatitude:theLatitude longitude:theLongitude spanHeight:theSpanHeight spanWidth:theSpanWidth] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    [self.mapView setRegion:MKCoordinateRegionMake(location, MKCoordinateSpanMake(spanHeight, spanWidth)) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) addAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle atLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
    [self.mapView addAnnotation:[DTMapAnnotation annotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:theLatitude longitude:theLongitude]];
}

@end
