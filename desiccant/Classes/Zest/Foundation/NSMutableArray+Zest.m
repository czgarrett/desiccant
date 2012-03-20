//
//  NSArray+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSMutableArray+Zest.h"

@implementation NSMutableArray ( Zest )

- (NSMutableArray *) pushObject:(id)object
{
    [self addObject:object];
	return self;
}

- (NSMutableArray *) pushObjects:(id)object,...
{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do
	{
		[self addObject:obj];
		obj = (__bridge id)va_arg(objects, void *);
	} while (obj);
	va_end(objects);
	return self;
}

- (id) pullObject
{
	if ([self count] == 0) return nil;
	
	id firstObject = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return firstObject;
}

- (void) addObjectUnlessNil: (NSObject *) object {
   if (object != nil) {
      [self addObject: object];
   }
}

- (id) pull
{
	return [self pullObject];
}

- (NSMutableArray *)push:(id)object
{
	return [self pushObject:object];
}

- (id) pop {
   id result = [self lastObject];
   [self removeLastObject];
   return result;
}

- (id) popObject
{
	if ([self count] == 0) return nil;
	
    id lastObject = [self lastObject];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) scramble
{
   if ([self count] > 1) {
      for (int i=0; i<(((int)[self count])-2); i++) {
         int other = (i+(random()%([self count]-i)));
         [self exchangeObjectAtIndex:i withObjectAtIndex: other];
      }
   }
	return self;
}

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

- (BOOL) isMutable {
   return YES;
}

- (void) addCGPointValueWithX: (CGFloat) x y: (CGFloat) y {
   [self addObject: [NSValue valueWithCGPoint: CGPointMake(x,y)]];
}



@end


@interface FixCategoryBugNSMutableArray : NSObject {}
@end
@implementation FixCategoryBugNSMutableArray
@end
