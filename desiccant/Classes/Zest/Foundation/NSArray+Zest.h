//
//  NSArray+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray ( Zest )

- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSDictionary *) dictionaryAtIndex:(NSUInteger)index;
- (NSArray *) arrayAtIndex:(NSUInteger)index;
- (NSMutableArray *)mutableArrayAtIndex:(NSUInteger)index;

- (NSArray *) arrayByRemovingObject: (id) object;

- (NSMutableArray *) collectWithSelector: (SEL) selector;

- (BOOL) empty;
// Returns a new array with the contents of this array reversed
- (NSMutableArray *) reversed;
- (BOOL) isEmpty;
- (BOOL) isMutable;
- (id) firstObject;
- (NSArray *)inRandomOrder;

- (NSArray *) arrayBySortingStrings;
- (NSMutableArray *) shuffledArray;

@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;
@property (readonly) NSString *stringValue;

- (NSArray *) uniqueMembers;
- (NSArray *) unionWithArray: (NSArray *) array;
- (NSArray *) intersectionWithArray: (NSArray *) array;

// Note also see: makeObjectsPeformSelector: withObject:. Map collects the results a la mapcar in Lisp
- (NSArray *) map: (SEL) selector;
- (NSArray *) map: (SEL) selector withObject: (id)object;
- (NSArray *) map: (SEL) selector withObject: (id)object1 withObject: (id)object2;

- (NSArray *) collect: (SEL) selector withObject: (id) object1 withObject: (id) object2;
- (NSArray *) collect: (SEL) selector withObject: (id) object1;
- (NSArray *) collect: (SEL) selector;

- (NSArray *) reject: (SEL) selector withObject: (id) object1 withObject: (id) object2;
- (NSArray *) reject: (SEL) selector withObject: (id) object1;
- (NSArray *) reject: (SEL) selector;

- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;

@end

