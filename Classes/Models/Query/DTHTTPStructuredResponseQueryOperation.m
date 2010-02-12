//
//  DTHTTPStructuredResponseQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPStructuredResponseQueryOperation.h"
#import "Zest.h"

@interface DTHTTPStructuredResponseQueryOperation()
@property (nonatomic, retain, readonly) NSObject *parsedResultObject;
@property (nonatomic, retain) NSObject *dtParsedResultObject;
@end

@implementation DTHTTPStructuredResponseQueryOperation
@synthesize resultObjectParser, rows, dtParsedResultObject;

- (void)dealloc {
	self.resultObjectParser = nil;
	self.rows = nil;
	self.dtParsedResultObject = nil;
	
	[super dealloc];
}

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	if (self = [super initWithURL:theURL delegate:theDelegate]) {
		self.resultObjectParser = theResultObjectParser;
	}
	return self;
}

+ (id)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate resultObjectParser:theResultObjectParser] autorelease];
}

- (BOOL)parseResponseData {
	if (!self.parsedResultObject) {
		self.error = @"Failed to parse response data.";
		return NO;
	}
	if (([self.parsedResultObject isKindOfClass:NSArray.class] && [resultObjectParser parseArraySuccessfully:(NSArray *)self.parsedResultObject]) ||
		 ([self.parsedResultObject isKindOfClass:NSDictionary.class] && [resultObjectParser parseDictionarySuccessfully:(NSDictionary *)self.parsedResultObject]))
	{
		self.rows = [NSMutableArray arrayWithArray:[resultObjectParser rows]];
		return YES;
	}
	else {
		self.error = [resultObjectParser errorString];
		return NO;
	}	
}

- (NSObject *)parsedResultObject {
	unless (dtParsedResultObject) {
		self.dtParsedResultObject = [self resultObject];
	}
	return dtParsedResultObject;
}

// Subclasses must implement this and return an array or dictionary that can be parsed by the resultObjectParser based on the resultData
- (NSObject *)resultObject {
	NSAssert (0, @"DTHTTPStructuredResponseQueryOperation subclass must override resultObject");
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
