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
	if (self = [super init]) {
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
			  stringByAppendingString:name] 
			 stringByAppendingNewLine:address1] 
			stringByAppendingNewLine:address2] 
			stringByAppendingNewLine:[self cityStateZipLine]];
}

- (NSString *)cityStateZipLine {
	NSString *line = [NSString string];
	if (city) {
		line = [line stringByAppendingString:city];
	}
	if ([line length] > 0 && state) {
		line = [line stringByAppendingString:@", "];
	}
	if (state) {
		line = [line stringByAppendingString:state];
	}
	if ([line length] > 0 && zip) {
		line = [line stringByAppendingString:@" "];
	}
	if (zip) {
		line = [line stringByAppendingString:zip];
	}
	return line;
}

@end
