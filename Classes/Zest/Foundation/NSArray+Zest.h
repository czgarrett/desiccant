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
- (NSArray *) arrayByRemovingObject: (id) object;

- (NSMutableArray *) collectWithSelector: (SEL) selector;

- (BOOL) empty;
// Returns a new array with the contents of this array reversed
- (NSMutableArray *) reversed;
- (BOOL) isEmpty;
- (id) firstObject;
- (NSArray *)inRandomOrder;

- (NSArray *) arrayBySortingStrings;
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

@end

@interface NSMutableArray (Zest)
- (NSMutableArray *) removeFirstObject;
- (NSMutableArray *) reverse;
- (NSMutableArray *) scramble;
@property (readonly, getter=reverse) NSMutableArray *reversed;
- (NSMutableArray *)pushObject:(id)object;
- (NSMutableArray *)pushObjects:(id)object,...;
- (id) popObject;
- (id) pullObject;

// Synonyms for traditional use
- (NSMutableArray *)push:(id)object;
- (id) pop;
- (id) pull;
@end
