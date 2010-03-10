//
//  MKMapView+Zest.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "MKMapView+Zest.h"


@implementation MKMapView(Zest)

//- (void)dealloc {
//    [super dealloc];
//}

- (MKUserLocation *)activeUserLocation {
	for (id<MKAnnotation>annotation in self.annotations) {
		if ([annotation isKindOfClass:MKUserLocation.class]) return annotation;
	}
	return nil;
}

- (BOOL)hasActiveUserLocation {
	return [self activeUserLocation] != nil;
}

@end
