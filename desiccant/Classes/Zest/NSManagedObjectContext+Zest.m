//
//  NSManagedObjectContext+Zest.m
//  ProLog
//
//  Created by Christopher Garrett on 9/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#ifdef __IPHONE_3_0
#import "NSManagedObjectContext+Zest.h"
#import "Zest.h"

@implementation NSManagedObjectContext ( Zest )

- (NSManagedObject *) objectWithStringID: (NSString *) url {
   return [self objectWithID: [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation: [NSURL URLWithString: url]]];
}


- (NSInteger) count: (NSString *) entityName {
   return [[self all: entityName] count];
}

- (NSArray *) all: (NSString *) entityName {
   return [self findEntities: entityName predicate: nil];
}

- (void) deleteAll: (NSString *) entityName {
   for (NSManagedObject *entity in [self all: entityName]) {
      [self deleteObject: entity];
   }
}

- (NSManagedObject *) findFirstEntity: (NSString *) entityName predicate: (NSPredicate *) predicate {
   NSArray *array = [self findEntities: entityName predicate: predicate];
   if ([array count] > 0) {
      return [array objectAtIndex: 0];
   } 
   return nil;
   
}

- (void) logDetailedError: (NSError *) error {
   DTLog(@"Overall error: %@", [error localizedDescription]);
   NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
   if(detailedErrors != nil && [detailedErrors count] > 0) {
      for(NSError* detailedError in detailedErrors) {
         DTLog(@"  DetailedError: %@", [detailedError userInfo]);
      }
   }
   else {
      DTLog(@"  %@", [error userInfo]);
   }
}

- (NSArray *) findEntities: (NSString *) entityName predicate: (NSPredicate *) predicate sortDescriptors: (NSArray *) sortDescriptors {
   NSEntityDescription *entityDescription = [NSEntityDescription
                                             entityForName: entityName inManagedObjectContext: self];
   NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
   [request setEntity:entityDescription];
   if (predicate) {
      [request setPredicate:predicate];      
   }
   if (sortDescriptors) {
      [request setSortDescriptors: sortDescriptors];      
   }
   NSError *error;
   NSArray *result = [self executeFetchRequest:request error:&error];
   if (result == nil) {
      DTLog(@"Find error");
      //[self handleUnexpectedError: error];
   }
   return result;   
}


- (NSArray *) findEntities: (NSString *) entityName predicate: (NSPredicate *) predicate {
   return [self findEntities: entityName predicate: predicate sortDescriptors: nil];
}


@end
#endif

@interface FixCategoryBugNSManagedObjectContext : NSObject {}
@end
@implementation FixCategoryBugNSManagedObjectContext
@end