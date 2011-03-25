//
//  MKMapView+Zest.m
//
//  Created by Curtis Duhn on 12/29/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "MKMapView+Zest.h"
#import <MapKit/MapKit.h>

@implementation MKMapView(Zest)

//- (void)dealloc {
//    [super dealloc];
//}

- (MKUserLocation *)activeUserLocation {
	for (id <MKAnnotation> annotation in self.annotations) {
		if ([(NSObject *)annotation isKindOfClass:MKUserLocation.class]) {
			return annotation;
		}
	}
	return nil;
}

- (BOOL)hasActiveUserLocation {
	return [self activeUserLocation] != nil;
}

- (NSArray *)nonUserLocationAnnotations {
	NSMutableArray *filteredAnnotations = [NSMutableArray arrayWithArray:self.annotations];
	MKUserLocation *annotationToFilter = [self activeUserLocation];
	if (annotationToFilter) [filteredAnnotations removeObject:annotationToFilter];
	return filteredAnnotations;
}

@end


@interface FixCategoryBugMKMapView : NSObject {}
@end
@implementation FixCategoryBugMKMapView
@end
