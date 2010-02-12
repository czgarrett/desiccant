//
//  ACAsyncQueryOperation.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTAsyncQueryOperation.h"
#import "desiccant.h"

#pragma mark Private Interface
@interface DTAsyncQueryOperation()
@property BOOL updating;
@end

#pragma mark Class Implementation
@implementation DTAsyncQueryOperation
@synthesize updating, delegate;

- (void)dealloc {
    [delegate release];    
    [super dealloc];
}

- (id)initWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate {
    if (self = [super init]) {
        self.delegate = newDelegate;
    }
    return self;
}

+ (id)operationWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

- (BOOL)isExecuting {
	if ([self isConcurrent]) {
		return executing;
	}
	else {
		return [super isExecuting];
	}
}

- (BOOL)isFinished {
	if ([self isConcurrent]) {
		return finished;
	}
	else {
		return [super isFinished];
	}
}

- (void)start {
	if ([self isConcurrent]) {
		self.updating = YES;
		[delegate performSelectorOnMainThread:@selector(operationWillStartLoading:) withObject:self waitUntilDone:YES];
		if ([self isCancelled])
		{
			// Must move the operation to the finished state if it is canceled.
			[self willChangeValueForKey:@"isFinished"];
			finished = YES;
			self.updating = NO;
			[self didChangeValueForKey:@"isFinished"];
			[delegate performSelectorOnMainThread:@selector(operationDidCancelLoading:) withObject:self waitUntilDone:YES];
			return;
		}
		
		// If the operation is not canceled, begin executing the task.
		[self willChangeValueForKey:@"isExecuting"];
		executing = YES;
		[self didChangeValueForKey:@"isExecuting"];
		[self startQuery];
	}
	else {
		// Run the default, non-concurrent main method
		[super start];
	}
}

- (void)completeOperationWithError:(BOOL)hadError {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
	
    executing = NO;
    finished = YES;
	self.updating = NO;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
	
	if ([self isCancelled]) {
		[delegate performSelectorOnMainThread:@selector(operationDidCancelLoading:) withObject:self waitUntilDone:YES];
	}
	else if (hadError) {
		[delegate performSelectorOnMainThread:@selector(operationDidFailLoading:) withObject:self waitUntilDone:YES];
	}
	else {
		[delegate performSelectorOnMainThread:@selector(operationDidFinishLoading:) withObject:self waitUntilDone:YES];
	}
}

// This only gets called if isConcurrent returns NO, which is the default.
- (void)main {
    @synchronized (self) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        self.updating = YES;
        
        [delegate performSelectorOnMainThread:@selector(operationWillStartLoading:) withObject:self waitUntilDone:YES];
        if (![self isCancelled]) {
			if ([self executeQuery]) {
				self.updating = NO;
				[delegate performSelectorOnMainThread:@selector(operationDidFinishLoading:) withObject:self waitUntilDone:YES];
			}
			else if ([self isCancelled]) {
				self.updating = NO;
				[delegate performSelectorOnMainThread:@selector(operationDidCancelLoading:) withObject:self waitUntilDone:YES];
			}
			else {
				self.updating = NO;
				[delegate performSelectorOnMainThread:@selector(operationDidFailLoading:) withObject:self waitUntilDone:YES];
			}
		}
		else {
			self.updating = NO;
			[delegate performSelectorOnMainThread:@selector(operationDidCancelLoading:) withObject:self waitUntilDone:YES];
		}
        [pool release];
    }
}

// Subclasses should override this to execute a non-concurrent (blocking) query.  Return YES if successful, NO otherwise.
// This only gets called if isConcurrent returns NO, which is the default.
- (BOOL)executeQuery { 
	DTAbstractMethod
    return YES;
}

// Subclasses should override this to start a concurrent (non-blocking) query.  You must also:
//  1. Override isConcurrent and return YES.
//  2. Call -completeOperationWithError: once the query finishes or is aborted due to cancel or error.
- (void)startQuery {
	DTAbstractMethod
}

// If a query is successful, subclasses should return their query results when this is called
- (NSArray *)rows {
    return [NSArray array];
}

// If a query is unsuccessful, subclasses should return an appropriate error message when this is called.
- (NSString *)error {
    return [NSString string];
}

@end
