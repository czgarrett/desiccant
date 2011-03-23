//
//  DTPListQueryOperation.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTPListQueryOperation.h"


@interface DTPListQueryOperation()
@property (nonatomic, retain) NSArray *rows;
@property (nonatomic, retain) NSString *error;
@end

@implementation DTPListQueryOperation
@synthesize fileName, rows, error;

- (void)dealloc {
    self.fileName = nil;
    self.rows = nil;
    self.error = nil;
    
    [super dealloc];
}

- (id)initOperationWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryOperationDelegate> *)aDelegate {
    if ((self = [super initWithDelegate:aDelegate])) {
        self.fileName = aFileName;
    }
    return self;
}

+ (DTPListQueryOperation *)operationWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryOperationDelegate> *)aDelegate {
    return [[[self alloc] initOperationWithFileNamed:aFileName delegate:aDelegate] autorelease];
}

// Subclasses should override this to execute the query.  Return YES if successful, NO otherwise.
- (BOOL)executeQuery {
//    NSString *errorDesc = nil;
//    NSPropertyListFormat format;
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    NSAssert1 (plistPath != nil, @"File not found: %@", fileName);
//    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//    NSAssert1 (plistPath != nil, @"Error loading XML at path: %@", plistPath);
//    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
//                                          propertyListFromData:plistXML
//                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
//                                          format:&format errorDescription:&errorDesc];
    self.rows = [NSArray arrayWithContentsOfFile:fileName];
    if (!rows) {
        self.error = [NSString stringWithFormat:@"Error reading array from plist file: %@", fileName];
        return NO;
    }
    return YES;
}

@end
