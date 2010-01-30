//
//  DTHTTPQuery.m
//  PortablePTO
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPQuery.h"


@interface DTHTTPQuery()
@end

@implementation DTHTTPQuery
@synthesize url, parser, body, method; //operation, 

- (void)dealloc {
	self.url = nil;
	self.parser = nil;
//	self.operation = nil;
	self.method = nil;
	self.body = nil;
	[super dealloc];
}

- (id)initWithURL:(NSURL *)newURL queryDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)newParser {
	if (self = (DTHTTPQuery *)[super initQueryWithDelegate:newDelegate]) {
		self.url = newURL;
		self.delegate = newDelegate;
		self.parser = newParser;
		self.method = @"GET";
		self.body = nil;
	}
	return self;
}

+ (id)queryWithURL:(NSURL *)url queryDelegate:(NSObject <DTAsyncQueryDelegate> *)delegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser {
	return [[[self alloc] initWithURL:url queryDelegate:delegate resultObjectParser:parser] autorelease];
}

@end
