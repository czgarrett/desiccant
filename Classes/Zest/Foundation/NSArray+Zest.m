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

#pragma mark StringExtensions
- (NSArray *) arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]]) [sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) stringValue
{
	return [self componentsJoinedByString:@" "];
}

#pragma mark UtilityExtensions
- (NSArray *) uniqueMembers
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
	{
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
	return copy;
}

- (NSArray *) unionWithArray: (NSArray *) anArray
{
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSArray *) intersectionWithArray: (NSArray *) anArray
{
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if (![anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uniqueMembers];
}

// A la LISP, will return an array populated with values
- (NSArray *) map: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *results = [NSMutableArray array];
	for (id eachitem in self)
	{
		if (![eachitem respondsToSelector:selector])
		{
			[results addObject:[NSNull null]];
			continue;
		}
		
		id riz = [eachitem objectByPerformingSelector:selector withObject:object1 withObject:object2];
		if (riz)
			[results addObject:riz];
		else
			[results addObject:[NSNull null]];
	}
	return results;
}

- (NSArray *) map: (SEL) selector withObject: (id) object1
{
	return [self map:selector withObject:object1 withObject:nil];
}

- (NSArray *) map: (SEL) selector
{
	return [self map:selector withObject:nil];
}


// NOTE: Selector must return BOOL
- (NSArray *) collect: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *riz = [NSMutableArray array];
	for (id eachitem in self)
	{
		BOOL yorn;
		NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
		if (strcmp([eachriz objCType], "c") == 0)
		{
			[eachriz getValue:&yorn];
			if (yorn) [riz addObject:eachitem];
		}
	}
	return riz;
}

- (NSArray *) collect: (SEL) selector withObject: (id) object1
{
	return [self collect:selector withObject:object1 withObject:nil];
}

- (NSArray *) collect: (SEL) selector
{
	return [self collect:selector withObject:nil withObject:nil];
}

// NOTE: Selector must return BOOL
- (NSArray *) reject: (SEL) selector withObject: (id) object1 withObject: (id) object2
{
	NSMutableArray *riz = [NSMutableArray array];
	for (id eachitem in self)
	{
		BOOL yorn;
		NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
		if (strcmp([eachriz objCType], "c") == 0)
		{
			[eachriz getValue:&yorn];
			if (!yorn) [riz addObject:eachitem];
		}
	}
	return riz;
}

- (NSArray *) reject: (SEL) selector withObject: (id) object1
{
	return [self reject:selector withObject:object1 withObject:nil];
}

- (NSArray *) reject: (SEL) selector
{
	return [self reject:selector withObject:nil withObject:nil];
}
@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UtilityExtensions)
- (NSMutableArray *) reverse
{
	for (int i=0; i<(floor([self count]/2.0)); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	return self;
}

- (NSMutableArray *) removeFirstObject
{
	[self removeObjectAtIndex:0];
	return self;
}

@end
