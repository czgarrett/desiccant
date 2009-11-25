//
//  DTJSONQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTJSONQueryOperation.h"
#import "JSON.h"
#import "Zest.h"

@interface DTJSONQueryOperation()
@end

@implementation DTJSONQueryOperation
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

+ (DTJSONQueryOperation *)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate resultObjectParser:theResultObjectParser] autorelease];
}

- (void)prepareForQuery {
}

- (BOOL)parseResponseData {
	NSString *json = [NSString stringWithCString:[[responseData nullTerminated] bytes] encoding:NSUTF8StringEncoding];
	NSObject *parsedObject = (NSObject *)[json JSONValue];
	if (!parsedObject) {
		self.error = @"Failed to parse JSON data.";
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


@end
