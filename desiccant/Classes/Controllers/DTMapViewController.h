//
//  DTMapViewController.h
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#ifdef __IPHONE_3_0

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DTViewController.h"


@interface DTMapViewController : DTViewController <MKMapViewDelegate> {
    CLLocationDegrees defaultLatitude;
    CLLocationDegrees defaultLongitude;
    CLLocationDegrees defaultLatitudeDelta;
    CLLocationDegrees defaultLongitudeDelta;

//	UIView *mapManagerView;
//	MKMapView *mapView;
//	UIToolbar *mapDetailsToolbar;
	UIBarButtonItem *currentLocationButton;
	MKMapType defaultMapType;
	CGFloat annotationBoundingRegionScalingFactor;
	BOOL hideDisclosureButtons;
}

@property (nonatomic) CLLocationDegrees defaultLatitude;
@property (nonatomic) CLLocationDegrees defaultLongitude;
@property (nonatomic) CLLocationDegrees defaultLatitudeDelta;
@property (nonatomic) CLLocationDegrees defaultLongitudeDelta;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIBarButtonItem *currentLocationButton;
@property (nonatomic) MKMapType defaultMapType;
@property (nonatomic) CGFloat annotationBoundingRegionScalingFactor;
@property (nonatomic) BOOL hideDisclosureButtons;

// Subclasses may override this if they want to change the default span shown for zero or one annotations
@property (nonatomic, readonly) MKCoordinateSpan defaultSpan;
// Subclasses may override this if they want to change the default center point shown for zero annotations
@property (nonatomic, readonly) CLLocationCoordinate2D defaultCenterCoord;
// Returns a default region based on defaultSpan and defaultCenterCoord
@property (nonatomic, readonly) MKCoordinateRegion defaultRegion;

- (id) initWithLatitude:(CLLocationDegrees)theLatitude 
              longitude:(CLLocationDegrees)theLongitude 
             latitudeDelta:(CLLocationDegrees)theLatitudeDelta 
              longitudeDelta:(CLLocationDegrees)theLongitudeDelta;

+ (DTMapViewController *) controllerWithLatitude:(CLLocationDegrees)theLatitude 
                                       longitude:(CLLocationDegrees)theLongitude 
                                      latitudeDelta:(CLLocationDegrees)theLatitudeDelta 
                                       longitudeDelta:(CLLocationDegrees)theLongitudeDelta;

- (void)addAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle atLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;
- (MKCoordinateRegion)annotationBoundingRegion:(BOOL)includeUserLocation;
- (void)centerMapAroundAnnotationsAnimated:(BOOL)animated includeUserLocation:(BOOL)includeUserLocation;
- (IBAction)currentLocationButtonClicked:(id)sender;

@end

#endif