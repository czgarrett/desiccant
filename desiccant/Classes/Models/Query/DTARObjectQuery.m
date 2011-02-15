//
//  DTARObjectQuery.m
//
//  Created by Curtis Duhn on 12/4/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTARObjectQuery.h"
#import "DTARObjectQueryOperation.h"

@interface DTARObjectQuery()
@end

@implementation DTARObjectQuery
@synthesize arObjectClass;

- (void)dealloc {
	self.arObjectClass = nil;
	[super dealloc];
}

- (id)initQueryWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate {
	if (self = [super initQueryWithDelegate:newDelegate]) {
		self.arObjectClass = theARObjectClass;
	}
	return self;
}

+ (id)queryWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate {
	return [[[self alloc] initQueryWithClass:theARObjectClass delegate:newDelegate] autorelease];
}

// Subclasses must override this to construct and return custom query objects
- (DTAsyncQueryOperation *)constructQueryOperation {
	return [DTARObjectQueryOperation operationWithClass:[arObjectClass class] delegate:self];
}

@end
