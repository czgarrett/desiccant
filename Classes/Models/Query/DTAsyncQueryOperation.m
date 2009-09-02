//
//  ACAsyncQueryOperation.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTAsyncQueryOperation.h"

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

+ (DTAsyncQueryOperation *)operationWithDelegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

- (void)main {
    @synchronized (self) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        self.updating = YES;
        
        [delegate performSelectorOnMainThread:@selector(operationWillStartLoading:) withObject:self waitUntilDone:YES];
        
        if ([self executeQuery]) {
            self.updating = NO;
            [delegate performSelectorOnMainThread:@selector(operationDidFinishLoading:) withObject:self waitUntilDone:YES];
        }
        else {
            self.updating = NO;
            [delegate performSelectorOnMainThread:@selector(operationDidFailLoading:) withObject:self waitUntilDone:YES];
        }
        [pool release];
    }
}

// Subclasses should override this to execute the query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery { 
    return YES;
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
