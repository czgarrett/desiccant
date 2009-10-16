//
//  DTMapAnnotation.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "desiccant.h"


@interface DTMapAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;
+ (DTMapAnnotation *)annotationWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;

@end
