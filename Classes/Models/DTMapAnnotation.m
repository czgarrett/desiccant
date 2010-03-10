//
//  DTMapAnnotation.m
//  iRevealMaui
//
//  Created by Curtis Duhn on 10/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTMapAnnotation.h"


@interface DTMapAnnotation()
@end

@implementation DTMapAnnotation
@synthesize title, subtitle, coordinate;

- (void)dealloc {
    self.title = nil;
    self.subtitle = nil;
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
    if (self = [super init]) {
        self.title = theTitle;
        self.subtitle = theSubtitle;
        coordinate.latitude = theLatitude;
        coordinate.longitude = theLongitude;
    }
    return self;
}

+ (DTMapAnnotation *)annotationWithTitle:(NSString *)theTitle subtitle:(NSString *)theSubtitle latitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
    return [[[self alloc] initWithTitle:theTitle subtitle:theSubtitle latitude:theLatitude longitude:theLongitude] autorelease];
}

@end
