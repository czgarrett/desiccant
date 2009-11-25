//
//  DTQueryBuilderCell.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTQueryBuilderCell.h"


@interface DTQueryBuilderCell()
@end

@implementation DTQueryBuilderCell
@synthesize fieldLabel, textField;

- (void)dealloc {
	self.fieldLabel = nil;
	self.textField = nil;
	[super dealloc];
}

@end
