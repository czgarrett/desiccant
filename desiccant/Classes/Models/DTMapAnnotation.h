//
//  DTMapAnnotation.h
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#ifdef __IPHONE_3_0
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface DTMapAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

- (void) setTitle:(NSString *)title;
- (void) setSubtitle:(NSString *)subtitle;
- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;
+ (DTMapAnnotation *)annotationWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;

@end
#endif