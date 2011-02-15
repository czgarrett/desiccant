//
//  DTHTTPPListQueryOperation.m
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPPListQueryOperation.h"


@interface DTHTTPPListQueryOperation()
@end

@implementation DTHTTPPListQueryOperation

// Subclasses must implement this and return an array or dictionary that can be parsed by the resultObjectParser based on the resultData
- (NSObject *)resultObject {
	NSPropertyListFormat format;
	NSString *errorString;
	NSObject *result = (NSObject *)[NSPropertyListSerialization propertyListFromData:responseData mutabilityOption:NSPropertyListMutableContainers format:&format errorDescription:&errorString];	
	if (errorString) self.error = [errorString autorelease];
	if (result && !([result isKindOfClass:NSArray.class] || [result isKindOfClass:NSDictionary.class])) {
		self.error = @"PList response didn't represent a dictionary or array";
		return nil;
	}
	return result;
}

@end
