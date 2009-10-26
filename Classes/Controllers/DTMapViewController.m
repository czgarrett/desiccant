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
@synthesize latitude, longitude, spanHeight, spanWidth, mapDetailsToolbar, mapManagerView, currentLocationButton, mapView;



- (void)dealloc 
{
    self.mapView = nil;
	self.mapDetailsToolbar = nil;
	self.currentLocationButton = nil;
	self.mapManagerView = nil;

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
		self.view = self.view;
    }
    return self;
}

- (void) loadView {
    

	self.mapManagerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.mapManagerView setAutoresizesSubviews: YES];
	
	self.view = self.mapManagerView;
	
	self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - 44.0)] autorelease];
	self.mapView.mapType = MKMapTypeHybrid;
	
	self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;	
	[self.mapManagerView addSubview:self.mapView];
	self.mapView.showsUserLocation = YES;
	

	self.mapDetailsToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height - 44.0), self.view.frame.size.width, 44.0)] autorelease];	
	self.mapDetailsToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	[self.mapManagerView addSubview: mapDetailsToolbar];
	self.currentLocationButton = [[[UIBarButtonItem alloc] initWithTitle:@"L" style:UIBarButtonItemStyleBordered target:self action:@selector(currentLocationButtonClicked:)] autorelease];
	[self.mapDetailsToolbar setItems:[NSArray arrayWithObjects:self.currentLocationButton,nil]];
	
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

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    [self.mapView setRegion:MKCoordinateRegionMake(location, MKCoordinateSpanMake(spanHeight, spanWidth)) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

- (void) addAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle atLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
    [self.mapView addAnnotation:[DTMapAnnotation annotationWithTitle:annotationTitle subtitle:annotationSubtitle latitude:theLatitude longitude:theLongitude]];
}

- (IBAction)currentLocationButtonClicked:(id)sender
{
	// The user has clicked the "current location" button, so center on it
	[self.mapView setCenterCoordinate:[self.mapView userLocation].coordinate];
}
	
#pragma mark -
#pragma mark DELEGATES

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	// We return nil for the default view, which we'll need to do to get the "current user location" blue dot
	MKAnnotationView *annotationView = nil;
	
	if(annotation != self.mapView.userLocation)
	{
		
	}
	
	return annotationView;
}

@end
