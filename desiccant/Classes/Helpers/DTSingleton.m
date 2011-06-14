//
//  DTSingleton.m
//
//  Created by Curtis Duhn on 1/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTSingleton.h"
#import "Zest.h"

@interface DTSingleton()
@end

@implementation DTSingleton

+ (NSObject *)loadedSingleton {
	NSObject **staticSingletonAddress = [self staticSingleton];
	if (*staticSingletonAddress == nil) {
		*staticSingletonAddress = [[super allocWithZone:NULL] init];
	}
	return *staticSingletonAddress;
}

+ (NSObject **)staticSingleton {
	DTAbstractMethod
	return NULL;
}

+ (id)allocWithZone:(NSZone *)zone {
	return (id)[[self loadedSingleton] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
