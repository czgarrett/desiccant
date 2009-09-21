//
//  DTPListQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTPListQuery.h"
#import "DTPListQueryOperation.h"

@interface DTPListQuery()
@end

@implementation DTPListQuery
@synthesize fileName;

- (void)dealloc {
    self.fileName = nil;
    
    [super dealloc];
}

- (id)initQueryWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryDelegate> *)aDelegate {
    if (self = [super initQueryWithDelegate:aDelegate]) {
        self.fileName = aFileName;
    }
    return self;
}

+ (DTPListQuery *)queryWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryDelegate> *)aDelegate {
    return [[[self alloc] initQueryWithFileNamed:aFileName delegate:aDelegate] autorelease];
}

// Subclasses must override this to construct and return custom query objects with retain count 0 (autoreleased)
- (DTAsyncQueryOperation *)constructQueryOperation {
    return [DTPListQueryOperation operationWithFileNamed:fileName delegate:self];
}


@end
