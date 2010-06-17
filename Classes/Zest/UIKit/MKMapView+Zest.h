//
//  MKMapView+Zest.h
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MKMapView.h"

@interface MKMapView (Zest)
@property (nonatomic, readonly) BOOL hasActiveUserLocation;
@property (nonatomic, readonly, retain) MKUserLocation *activeUserLocation;
@property (nonatomic, readonly, retain) NSArray *nonUserLocationAnnotations;
@end
