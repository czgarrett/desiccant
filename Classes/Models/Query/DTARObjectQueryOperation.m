//
//  DTARObjectQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 12/4/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTARObjectQueryOperation.h"
#import "ARObject.h"

@interface DTARObjectQueryOperation()
@end

@implementation DTARObjectQueryOperation
@synthesize arObjectClass, rows, error;

- (void)dealloc {
	self.arObjectClass = nil;
	self.rows = nil;
	self.error = nil;
	
	[super dealloc];
}

- (id)initWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate {
	if (self = [super initWithDelegate:newDelegate]) {
		self.arObjectClass = theARObjectClass;
	}
	return self;
}

+ (id)operationWithClass:(Class)arObjectClass delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate {
	return [[[self alloc] initWithClass:arObjectClass delegate:newDelegate] autorelease];
}

// Subclasses should override this to execute the query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery {
	NSArray *models = [self findModelObjects];
	self.rows = [NSMutableArray arrayWithCapacity:[models count]];
	for (ARObject *model in models) {
		NSDictionary *dictionary = [self dictionaryForModel:model];
		[rows addObject:dictionary];
	}
	self.error = nil;
	return YES;
}

// Returns the result of findAll by default.  Subclasses may override this to return a subset.
- (NSArray *)findModelObjects {
	return [[arObjectClass class] findAll];
}

// Returns the raw attributes dictionary by default.  Subclasses may override this to return a custom dictionary.
- (NSDictionary *)dictionaryForModel:(ARObject *)model {
	return [model attributes]; 
}

@end
