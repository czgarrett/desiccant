//
//  DTHTTPStructuredResponseQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPStructuredResponseQueryOperation.h"


@interface DTHTTPStructuredResponseQueryOperation()
@end

@implementation DTHTTPStructuredResponseQueryOperation
@synthesize resultObjectParser, rows;

- (void)dealloc {
	self.resultObjectParser = nil;
	self.rows = nil;
	
	[super dealloc];
}

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	if (self = [super initWithURL:theURL delegate:theDelegate]) {
		self.resultObjectParser = theResultObjectParser;
	}
	return self;
}

+ (DTHTTPStructuredResponseQueryOperation *)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate resultObjectParser:theResultObjectParser] autorelease];
}

- (BOOL)parseResponseData {
	NSObject *parsedObject = [self resultObject];
	if (!parsedObject) {
		self.error = @"Failed to parse response data.";
		return NO;
	}
	if (([parsedObject isKindOfClass:NSArray.class] && [resultObjectParser parseArraySuccessfully:(NSArray *)parsedObject]) ||
		 ([parsedObject isKindOfClass:NSDictionary.class] && [resultObjectParser parseDictionarySuccessfully:(NSDictionary *)parsedObject]))
	{
		self.rows = [NSMutableArray arrayWithArray:[resultObjectParser rows]];
		return YES;
	}
	else {
		self.error = [resultObjectParser errorString];
		return NO;
	}	
}

// Subclasses must implement this and return an array or dictionary that can be parsed by the resultObjectParser based on the resultData
- (NSObject *)resultObject {
	NSAssert (0, @"DTHTTPStructuredResponseQueryOperation subclass must override resultObject");
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
