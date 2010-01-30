//
//  DTMapLinkControllerDelegate.h
//  iRevealMaui
//
//  Created by Curtis Duhn on 12/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTMapViewController.h"

@protocol DTMapLinkControllerDelegate <NSObject>

@optional
// Delegates should implement this and return YES if the map view controller should be pushed onto a nav stack
- (UINavigationController *) navigationController;
// Delegates may implement this and return a custom MKAnnotation.  Otherwise a DTMapAnnotation will be constructed by default.
- (id <MKAnnotation>) mapAnnotationWithTitle:(NSString *)annotationTitle subtitle:(NSString *)annotationSubtitle latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
// Delegates may implement this to return a custom subclass of DTMapViewController.  Otherwise a generic DTMapViewController will
// be used by default
- (DTMapViewController *) mapViewControllerWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude latitudeDelta:(CLLocationDegrees)spanHeight longitudeDelta:(CLLocationDegrees)spanWidth;

@end
