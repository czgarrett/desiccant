//
//  DTDrivingDirectionsViewController.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTDrivingDirectionsViewController.h"


@interface DTDrivingDirectionsViewController()
- (void)openDirectionsToHere;
- (void)openDirectionsFromHere;
@end

@implementation DTDrivingDirectionsViewController
@synthesize annotation, userLocation;

#pragma mark Memory management

- (void)dealloc {
	self.annotation = nil;
	self.userLocation = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithAnnotation:(id <MKAnnotation>)theAnnotation userLocation:(MKUserLocation *)theUserLocation {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.annotation = theAnnotation;
		self.userLocation = theUserLocation;
	}
	return self;
}

+ (id)controllerWithAnnotation:(id <MKAnnotation>)theAnnotation userLocation:(MKUserLocation *)theUserLocation {
	return [[[self alloc] initWithAnnotation:theAnnotation userLocation:theUserLocation] autorelease];
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"Info";
	[self startSectionWithTitle:[self.annotation title]];
//	[self addRowWithDedicatedCell:[self titleCell]];
	
	[self startSection];
	[self addRowWithDedicatedCell:[self directionsActionCellWithText:@"Directions To Here"]];
	[self addRowWithDedicatedCell:[self directionsActionCellWithText:@"Directions From Here"]];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == 0) [self openDirectionsToHere];
		if (indexPath.row == 1) [self openDirectionsFromHere];
	}
}

#pragma mark Public methods

//- (DTCustomTableViewCell *)titleCell {
//	DTCustomTableViewCell *titleCell = [[[DTCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
//	titleCell.textLabel.text = [self.annotation title];
//	return titleCell;
//}

- (DTCustomTableViewCell *)directionsActionCellWithText:(NSString *)text {
	DTCustomTableViewCell *newCell = [[[DTCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	newCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
	newCell.textLabel.textColor = [UIColor colorWithRed:0.427f green:0.518f blue:0.635f alpha:1.0f];
	newCell.textLabel.text = text;
	newCell.textLabel.textAlignment = UITextAlignmentCenter;
	return newCell;
}

- (void)openDirectionsToHere {
	[[UIApplication sharedApplication] openURL:[NSURL urlForDrivingDirectionsFrom:userLocation.location
//																	   forceTitle:nil
																	   forceTitle:@"Current Location"
																			   to:[[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude] autorelease]
																	   forceTitle:[annotation title]]];
}

- (void)openDirectionsFromHere {
	[[UIApplication sharedApplication] openURL:[NSURL urlForDrivingDirectionsFrom:[[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude] autorelease]
																	   forceTitle:[annotation title]
																			   to:userLocation.location
//																	   forceTitle:nil]];
																	   forceTitle:@"Current Location"]];
}




@end
