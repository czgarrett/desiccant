//
//  NSObject+Zest.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Zest) 

@property (nonatomic, retain, readonly) NSString *to_s;
@property (nonatomic, assign, readonly) NSInteger to_i;
@property (nonatomic, retain, readonly) NSURL *to_url;
@property (nonatomic, retain, readonly) NSDate *to_date;
@property (nonatomic, retain, readonly) NSNumber *to_n;
@property (nonatomic, retain, readonly) NSDate *toDate;

// Easy way to deserialize objects from NIBs.
// Deserializes all objects from the specified NIB and returns the first object
// that's an instance of the class on which this method was called.
+ (id)objectFromNib:(NSString *)nibName;

- (NSString *) detailDescription;

// Return YES if this object is the NSNull instance
- (BOOL) isNull;

// Return all superclasses of object
- (NSArray *) superclasses;

// Selector Utilities
- (NSInvocation *) invocationWithSelectorAndArguments: (SEL) selector,...;
- (BOOL) performSelector: (SEL) selector withReturnValueAndArguments: (void *) result, ...;
- (const char *) returnTypeForSelector:(SEL)selector;

// Request return value from performing selector
- (id) objectByPerformingSelectorWithArguments: (SEL) selector, ...;
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2;
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1;
- (id) objectByPerformingSelector:(SEL)selector;

// Delay Utilities
- (void) performSelector: (SEL) selector withCPointer: (void *) cPointer afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withInt: (int) intValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withFloat: (float) floatValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withBool: (BOOL) boolValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withDelayAndArguments: (NSTimeInterval) delay,...;

// Return Values, allowing non-object returns
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2;
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1;
- (id) valueByPerformingSelector:(SEL)selector;

// Access to object essentials for run-time checks. Stored by class in dictionary.
/* TODO fix after ARC is more stable
@property (readonly) NSDictionary *selectors;
@property (readonly) NSDictionary *properties;
@property (readonly) NSDictionary *ivars;
@property (readonly) NSDictionary *protocols;
 - (BOOL) hasProperty: (NSString *) propertyName;
 - (BOOL) hasIvar: (NSString *) ivarName;
*/
 
// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well
+ (BOOL) classExists: (NSString *) className;
+ (id) instanceOfClassNamed: (NSString *) className;

// Attempt selector if possible
/* TODO:  ARC gives a warning on implementation of these methods.  We should probably just remove these methods and replace with block methods
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1 withObject: (id) object2;
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1;
- (id) tryPerformSelector: (SEL) aSelector;
 */

// Choose the first selector that the object responds to
- (SEL) chooseSelector: (SEL) aSelector, ...;

// Create an archiver and encode the object into NSData.
- (NSData *) encodeIntoData;
+ (id) decodeFromData: (NSData *) data;

@end
