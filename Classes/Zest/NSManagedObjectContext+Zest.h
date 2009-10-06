//
//  NSManagedObjectContext+Zest.h
//  ProLog
//
//  Created by Christopher Garrett on 9/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//
#ifdef __IPHONE_3_0
#import <CoreData/CoreData.h>


@interface NSManagedObjectContext ( Zest ) 

- (NSInteger) count: (NSString *) entityName;
- (void) deleteAll: (NSString *) entityName;
- (NSArray *) all: (NSString *) entityName;

- (NSManagedObject *) findFirstEntity: (NSString *) entityName predicate: (NSPredicate *) predicate;
- (NSArray *) findEntities: (NSString *) entityName predicate: (NSPredicate *) predicate;

// Logs a tree of errors.  Core Data often returns an error that contains sub-errors useful for debugging.
- (void) logDetailedError: (NSError *) error;

@end
#endif