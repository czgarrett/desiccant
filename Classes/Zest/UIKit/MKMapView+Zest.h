//
//  MKMapView+Zest.h
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "MapKit/MKMapView.h"

@interface MKMapView (Zest)
@property (nonatomic, readonly) BOOL hasActiveUserLocation;
@property (nonatomic, readonly, retain) MKUserLocation *activeUserLocation;
@end
