//
//  DTResultObjectParser.m
//  PortablePTO
//
//  Created by Curtis Duhn on 12/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTResultObjectParser.h"


@interface DTResultObjectParser()
@end

@implementation DTResultObjectParser
@synthesize rows, errorString;

#pragma mark Memory management

- (void)dealloc {
	self.rows = nil;
	self.errorString = nil;
	
	[super dealloc];
}

#pragma mark Constructors

+ (id)parser {
	return [[[self alloc] init] autorelease];
}

#pragma mark Public methods

- (BOOL)parseArraySuccessfully:(NSArray *)array {
	self.errorString = @"Parser found unexpected array structure in results";
	self.rows = nil;
	return NO;
}

- (BOOL)parseDictionarySuccessfully:(NSDictionary *)dictionary {
	self.errorString = @"Parser found unexpected dictionary structure in results";
	self.rows = nil;
	return NO;
}

@end
