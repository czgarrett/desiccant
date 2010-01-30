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

- (BOOL) empty {
   return [self isEmpty];
}

- (NSMutableArray *) reversed {
   NSMutableArray *result = [NSMutableArray array];
   for (int i=[self count] - 1; i > -1; i--) {
      [result addObject: [self objectAtIndex: i]];
   }
   return result;
}
- (BOOL) isEmpty {
   return [self count] == 0;
}

- (id) firstObject {
   unless ([self empty]) {
      return [self objectAtIndex: 0];      
   }
   return nil;
}

- (NSArray *)inRandomOrder {
	NSMutableArray *randomArray = [NSMutableArray arrayWithArray:self];
	int n = [randomArray count];
	while (n > 1) {
		int rnd = arc4random() % n;
		int i = n - 1;
		[randomArray exchangeObjectAtIndex:i withObjectAtIndex:rnd];
		n--;
	}
	return randomArray;
}


@end
