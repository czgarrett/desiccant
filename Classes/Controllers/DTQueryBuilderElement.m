//
//  DTQueryBuilderElement.m
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTQueryBuilderElement.h"


@interface DTQueryBuilderElement()
@end

@implementation DTQueryBuilderElement
@synthesize type, text;

- (void)dealloc {
	self.type = nil;
	self.text = nil;
	
	[super dealloc];
}

- (id)initWithText:(NSString *)theText type:(NSObject <DTQueryBuilderElementType> *)theType {
	if (self = [super init]) {
		self.type = theType;
		self.text = theText;
	}
	return self;
}

+ (DTQueryBuilderElement *)elementWithText:(NSString *)theText type:(NSObject <DTQueryBuilderElementType> *)theType {
	return [[[self alloc] initWithText:theText type:theType] autorelease];
}

@end
