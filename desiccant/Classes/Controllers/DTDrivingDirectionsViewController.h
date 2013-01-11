//
//  DTDrivingDirectionsViewController.h
//  BlueDevils
//
//  Created by Curtis Duhn on 5/9/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTStaticTableViewController.h"
#import "DTCustomTableViewCell.h"


@interface DTDrivingDirectionsViewController : DTStaticTableViewController {
	id <MKAnnotation> annotation;
	MKUserLocation *userLocation;
}

@property (nonatomic, retain) id <MKAnnotation> annotation;
@property (nonatomic, retain) MKUserLocation *userLocation;

- (id)initWithAnnotation:(id <MKAnnotation>)theAnnotation userLocation:(MKUserLocation *)theUserLocation;
+ (id)controllerWithAnnotation:(id <MKAnnotation>)theAnnotation userLocation:(MKUserLocation *)theUserLocation;

// Returns the title cell.  Subclasses can override to customize.
//- (DTCustomTableViewCell *)titleCell;

// Returns a cell formatted for "Directions To Here".  Subclasses can override
// to customize.
- (DTCustomTableViewCell *)directionsActionCellWithText:(NSString *)text;

@end
