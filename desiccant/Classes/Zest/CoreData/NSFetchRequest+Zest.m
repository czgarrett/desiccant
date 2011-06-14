//
//  NSFetchRequest+Zest.m
//  WordTower
//
//  Created by Christopher Garrett on 2/6/10.
//  Copyright 2010 ZWorkbench, Inc.. All rights reserved.
//

#import "NSFetchRequest+Zest.h"
#import "NSSortDescriptor+Zest.h"

@implementation NSFetchRequest (Zest)

+ (NSFetchRequest *) fetchRequest {
   return [[NSFetchRequest alloc] init];
}

+ (NSFetchRequest *) fetchRequestFor: (NSString *) entityName inManagedObjectContext: (NSManagedObjectContext *) moc {
   NSFetchRequest *request = [self fetchRequest];
   [request setEntity: [NSEntityDescription entityForName:@"Player" inManagedObjectContext:moc]];
   return request;
}

- (void) sortAscending: (NSString *) propertyKey {
   NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortAscending: propertyKey];
   [self setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}



@end


@interface FixCategoryBugNSFetchRequest : NSObject {}
@end
@implementation FixCategoryBugNSFetchRequest
@end