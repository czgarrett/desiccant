//
//  NSFetchRequest+Zest.h
//  WordTower
//
//  Created by Christopher Garrett on 2/6/10.
//  Copyright 2010 ZWorkbench, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSFetchRequest (Zest)

+ (NSFetchRequest *) fetchRequest;
+ (NSFetchRequest *) fetchRequestFor: (NSString *) entityName inManagedObjectContext: (NSManagedObjectContext *) moc;

- (void) sortAscending: (NSString *) propertyKey;

@end
