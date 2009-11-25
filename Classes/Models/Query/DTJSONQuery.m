//
//  DTJSONQuery.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/20/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTJSONQuery.h"


@interface DTJSONQuery()
@end

@implementation DTJSONQuery
@synthesize url, parser, operation, body, method;

- (void)dealloc {
	self.url = nil;
	self.parser = nil;
	self.operation = nil;
	self.method = nil;
	self.body = nil;
	[super dealloc];
}

- (id)initWithURL:(NSURL *)newURL queryDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)newParser {
	if (self = (DTJSONQuery *)[super initQueryWithDelegate:newDelegate]) {
		self.url = newURL;
		self.delegate = newDelegate;
		self.parser = newParser;
		self.method = @"GET";
		self.body = nil;
	}
	return self;
}

+ (DTJSONQuery *)queryWithURL:(NSURL *)url queryDelegate:(NSObject <DTAsyncQueryDelegate> *)delegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser {
	return [[[self alloc] initWithURL:url queryDelegate:delegate resultObjectParser:parser] autorelease];
}

- (DTAsyncQueryOperation *)constructQueryOperation {
	DTJSONQueryOperation *newOperation = [DTJSONQueryOperation queryWithURL:url delegate:self resultObjectParser:parser];
	newOperation.method = method;
	newOperation.body = body;
	return newOperation;
}


@end
