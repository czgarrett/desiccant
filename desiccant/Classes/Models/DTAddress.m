//
//  DTAddress.m
//  BlueDevils
//
//  Created by Curtis Duhn on 1/26/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTAddress.h"
#import "Zest.h"

@interface DTAddress()
@end

@implementation DTAddress
@synthesize name, address1, address2, city, state, zip;

- (void)dealloc {
	self.name = nil;
	self.address1 = nil;
	self.address2 = nil;
	self.city = nil;
	self.state = nil;
	self.zip = nil;
	
    [super dealloc];
}

- (id) initWithName:(NSString *)theName
		   address1:(NSString *)theAddress1
		   address2:(NSString *)theAddress2
			   city:(NSString *)theCity
			  state:(NSString *)theState
				zip:(NSString *)theZip 
{
	unless ([theName length] + [theAddress1 length] + [theAddress2 length] + [theCity length] + [theState length] + [theZip length]) return nil;
	if ((self = [super init])) {
		self.name = theName;
		self.address1 = theAddress1;
		self.address2 = theAddress2;
		self.city = theCity;
		self.state = theState;
		self.zip = theZip;
	}
	return self;
}

+ (id) addressWithName:(NSString *)theName
			  address1:(NSString *)theAddress1
			  address2:(NSString *)theAddress2
				  city:(NSString *)theCity
				 state:(NSString *)theState
				   zip:(NSString *)theZip 
{
	return [[[self alloc] initWithName:theName address1:theAddress1 address2:theAddress2 city:theCity state:theState zip:theZip] autorelease];
}

- (NSString *)description {
	return [[[[[NSString string] 
			  stringByAppendingStringOrNil:name] 
			 stringByAppendingNewLine:address1.unlessEmpty] 
			stringByAppendingNewLine:address2.unlessEmpty] 
			stringByAppendingNewLine:[self cityStateZipLine].unlessEmpty];
}

- (NSString *)cityStateZipLine {
	NSString *line = [NSString string];
	if (city) {
		line = [line stringByAppendingStringOrNil:city];
	}
	if ([line length] > 0 && state) {
		line = [line stringByAppendingStringOrNil:@", "];
	}
	if (state) {
		line = [line stringByAppendingStringOrNil:state];
	}
	if ([line length] > 0 && zip) {
		line = [line stringByAppendingStringOrNil:@" "];
	}
	if (zip) {
		line = [line stringByAppendingStringOrNil:zip];
	}
	return line;
}

- (NSString *)mapAnnotationTitle {
	NSString *title;
	
	if (name) title = name;
	else if (address1) title = address1;
	else if ([self cityStateZipLine]) title = [self cityStateZipLine];
	else title = @"Destination";
	
	return title;
}


@end
