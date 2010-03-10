//
//  NSArray+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSArray+Zest.h"
#import "Zest.h"

@implementation NSArray ( Zest )

- (NSMutableArray *) shuffledArray {
   NSMutableArray *result = [[[NSMutableArray alloc] initWithArray: self] autorelease];
   for (int i=0; i< [result count] * 10; i++) {
      int index1 = i % [result count]; 
      int index2 = rand() % [result count];
      if (index1 != index2) {
         [result exchangeObjectAtIndex: index1 withObjectAtIndex: index2];
      }
   }
   return result;
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    return (NSString *)[self objectAtIndex:index];
}

- (NSDictionary *) dictionaryAtIndex:(NSUInteger)index {
    return (NSDictionary *)[self objectAtIndex:index];
}

- (NSArray *) arrayByRemovingObject: (id) objectToRemove {
   NSMutableArray *result = [NSMutableArray array];
   for (id object in self) {
      if (object != objectToRemove) [result addObject: object];
   }
   return result;
}

- (NSMutableArray *) collectWithSelector: (SEL) selector {
   NSMutableArray *result = [NSMutableArray array];
   for (NSObject *object in self) {
      [result addObject: [object performSelector: selector]];
   }
   return result;
}



- (BOOL) empty {
   return [self count] == 0;
}

- (id) firstObject {
   unless ([self empty]) {
      return [self objectAtIndex: 0];      
   }
   return nil;
}


@end
