//
//  DTTableViewRow.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewRow.h"

@interface DTTableViewRow()
@end


@implementation DTTableViewRow
@synthesize cell, detailViewController, dataDictionary, dataInjector, reuseIdentifier, nibName;

- (void)dealloc {
	self.cell = nil;
	self.detailViewController = nil;
	self.dataDictionary = nil;
	self.reuseIdentifier = nil;
	self.nibName = nil;
    
    [super dealloc];
}

- (id)initWithCell:(DTCustomTableViewCell *)theCell nibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier {
	if (self = [super init]) {
		self.cell = theCell;
		self.nibName = theNibName;
		self.dataDictionary = theRowData;
		self.detailViewController = theDetailViewController;
		self.dataInjector = theDataInjector;
		self.reuseIdentifier = theReuseIdentifier;
		if (cell && dataDictionary) [cell setData:dataDictionary];
	}
	return self;
}

- (id)initWithCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)theData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector {
	return [self initWithCell:theCell nibNamed:nil data:theData detailViewController:theDetailViewController dataInjector:theDataInjector reuseIdentifier:theCell.reuseIdentifier];
}

- (id)initWithNibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier {
	return [self initWithCell:nil nibNamed:theNibName data:theRowData detailViewController:theDetailViewController dataInjector:theDataInjector reuseIdentifier:theReuseIdentifier];
}

+ (id)rowWithCell:(DTCustomTableViewCell *)cell data:(NSDictionary *)theData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)theDataInjector {
    return [[[self alloc] initWithCell:cell data:theData detailViewController:detailViewController dataInjector:theDataInjector] autorelease];
}

+ (id)rowWithNibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier {
	return [[[self alloc] initWithNibNamed:theNibName data:theRowData detailViewController:theDetailViewController dataInjector:theDataInjector reuseIdentifier:theReuseIdentifier] autorelease];
}

@end
