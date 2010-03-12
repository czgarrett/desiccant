//
//  DTMapViewController.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTMapViewController.h"
#import "DTMapAnnotation.h"
#import "Zest.h"

static const float kDefaultAnnotationBoundingRegionScalingFactor = 1.05;

@interface DTMapViewController()
@end

@implementation DTMapViewController
@synthesize defaultLatitude, defaultLongitude, defaultLatitudeDelta, defaultLongitudeDelta, currentLocationButton, defaultMapType, annotationBoundingRegionScalingFactor, hideDisclosureButtons;

#pragma mark Memory Management

- (void)dealloc 
{
    self.mapView = nil;
	self.currentLocationButton = nil;

    [super dealloc];
}

#pragma mark Constructors

- (id) initWithLatitude:(CLLocationDegrees)theLatitude 
              longitude:(CLLocationDegrees)theLongitude 
		  latitudeDelta:(CLLocationDegrees)theLatitudeDelta 
		 longitudeDelta:(CLLocationDegrees)theLongitudeDelta {
    if (self = [super init]) {
        self.defaultLatitude = theLatitude;
        self.defaultLongitude = theLongitude;
        self.defaultLatitudeDelta = theLatitudeDelta;
        self.defaultLongitudeDelta = theLongitudeDelta;
		self.defaultMapType = MKMapTypeHybrid;
		self.annotationBoundingRegionScalingFactor = kDefaultAnnotationBoundingRegionScalingFactor;
    }
    return self;
}


+ (DTMapViewController *) controllerWithLatitude:(CLLocationDegrees)theLatitude 
                                       longitude:(CLLocationDegrees)theLongitude 
								   latitudeDelta:(CLLocationDegrees)theLatitudeDelta 
								  longitudeDelta:(CLLocationDegrees)theLongitudeDelta; {
    return [[[self alloc] initWithLatitude:theLatitude longitude:theLongitude latitudeDelta:theLatitudeDelta longitudeDelta:theLongitudeDelta] autorelease];
}

#pragma mark UIViewController methods

- (void) loadView {
	self.view = [[[MKMapView alloc] initWithFrame:[self fullScreenViewBounds]] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.mapView.mapType = self.defaultMapType;
	self.mapView.delegate = self;

	self.currentLocationButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reticle.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(currentLocationButtonClicked:)] autorelease];
//	self.currentLocationButton = [[[UIBarButtonItem alloc] initWithTitle:@"L" style:UIBarButtonItemStyleBordered target:self action:@selector(currentLocationButtonClicked:)] autorelease];
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setRegion:self.defaultRegion animated:NO];
	[self setToolbarItems:[NSArray arrayWithObject:self.currentLocationButton]];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.mapView.showsUserLocation = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.mapView.showsUserLocation = NO;
}

#pragma mark Dynamic properties

- (MKMapView *)mapView {
	return (MKMapView *)self.view;
}

- (void)setMapView:(MKMapView *)theMapView {
	self.view = theMapView;
}

#pragma mark Public methods

- (void) addAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle atLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
    [self.mapView addAnnotation:[DTMapAnnotation annotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:theLatitude longitude:theLongitude]];
}

- (MKCoordinateRegion)annotationBoundingRegion:(BOOL)includeUserLocation {
    CLLocationDegrees left = -9999.0;
    CLLocationDegrees top = 9999.0;
    CLLocationDegrees right = 9999.0;
    CLLocationDegrees bottom = -9999.0;
	NSInteger boundedAnnotationsCount = 0;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
		if (includeUserLocation || ![annotation isKindOfClass:MKUserLocation.class]) {
			boundedAnnotationsCount++;
			if (annotation.coordinate.longitude > left) left = annotation.coordinate.longitude;
			if (annotation.coordinate.longitude < right) right = annotation.coordinate.longitude;
			if (annotation.coordinate.latitude < top) top = annotation.coordinate.latitude;
			if (annotation.coordinate.latitude > bottom) bottom = annotation.coordinate.latitude;
		}
    }

    CLLocationCoordinate2D center = [self defaultCenterCoord];
	MKCoordinateSpan span = [self defaultSpan];
	if (boundedAnnotationsCount >= 1) {
		center.latitude = (bottom + top) / 2;
		center.longitude = (left + right) / 2;
	}
	if (boundedAnnotationsCount >= 2) {
		span.latitudeDelta = (bottom - top) * self.annotationBoundingRegionScalingFactor;
		span.longitudeDelta = (left - right) * self.annotationBoundingRegionScalingFactor;
		if (span.latitudeDelta == 0.0 && span.latitudeDelta == 0.0) {
			span = [self defaultSpan];
		}
	}
    return MKCoordinateRegionMake(center, span);
}

- (void)centerMapAroundAnnotationsAnimated:(BOOL)animated includeUserLocation:(BOOL)includeUserLocation {
	MKCoordinateRegion fitRegion;
	MKCoordinateRegion boundingRegion = [self annotationBoundingRegion:includeUserLocation];
	fitRegion = [self.mapView regionThatFits:boundingRegion];
    [self.mapView setRegion:fitRegion animated:animated];
}

- (MKCoordinateSpan)defaultSpan 
{
	MKCoordinateSpan span;
	span.latitudeDelta = self.defaultLatitudeDelta;
	span.longitudeDelta = self.defaultLongitudeDelta;
	return span;
}

- (CLLocationCoordinate2D)defaultCenterCoord {
    CLLocationCoordinate2D coords;
    coords.latitude = self.defaultLatitude;
    coords.longitude = self.defaultLongitude;
    return coords;
}

- (MKCoordinateRegion)defaultRegion {
	return MKCoordinateRegionMake(self.defaultCenterCoord, self.defaultSpan);
}


#pragma mark Actions

- (IBAction)currentLocationButtonClicked:(id)sender
{
	if (self.mapView.userLocationVisible) {
		[self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
	}
	else {
		[self centerMapAroundAnnotationsAnimated:YES includeUserLocation:YES];
	}
}
	
#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == self.mapView.userLocation) return nil;
	
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"DTMapViewControllerGenericAnnotation"];

    if (!annotationView) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DTMapViewControllerGenericAnnotation"] autorelease];
		if (!self.hideDisclosureButtons) {
			annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		}
    }
    else {
        annotationView.annotation = annotation;
    }
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.animatesDrop = NO;
    annotationView.canShowCallout = YES;
	
    return annotationView;
}


@end
