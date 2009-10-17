//
//  DTMapViewController.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "desiccant.h"


@interface DTMapViewController : UIViewController {
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    CLLocationDegrees spanHeight;
    CLLocationDegrees spanWidth;

	UIView *mapManagerView;
	MKMapView *mapView;
	UIToolbar *mapDetailsToolbar;
	UIBarButtonItem *currentLocationButton;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) CLLocationDegrees spanHeight;
@property (nonatomic) CLLocationDegrees spanWidth;
@property (nonatomic, retain) UIView *mapManagerView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIToolbar *mapDetailsToolbar;
@property (nonatomic, retain) UIBarButtonItem *currentLocationButton;

- (id) initWithLatitude:(CLLocationDegrees)theLatitude 
              longitude:(CLLocationDegrees)theLongitude 
             spanHeight:(CLLocationDegrees)spanHeight 
              spanWidth:(CLLocationDegrees)spanWidth;

+ (DTMapViewController *) controllerWithLatitude:(CLLocationDegrees)theLatitude 
                                       longitude:(CLLocationDegrees)theLongitude 
                                      spanHeight:(CLLocationDegrees)spanHeight 
                                       spanWidth:(CLLocationDegrees)spanWidth;
- (void)addAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle atLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;


#pragma mark -
#pragma mark IBActions
- (IBAction)currentLocationButtonClicked:(id)sender;

@end
