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

+ (id)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate resultObjectParser:theResultObjectParser] autorelease];
}

// Subclasses must implement this and return an array or dictionary that can be parsed by the resultObjectParser based on the resultData
- (NSObject *)resultObject {
	NSString *json = [NSString stringWithCString:[[responseData nullTerminated] bytes] encoding:NSUTF8StringEncoding];
	return (NSObject *)[json JSONValue];
}

@end
