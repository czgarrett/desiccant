//
//  NSUserDefaults+Zest.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSUserDefaults+Zest.h"
#import "NSObject+Zest.h"
#import "NSDate+Zest.h"
#import <objc/runtime.h>

@implementation NSUserDefaults (Zest) 

// Returns the key used by persistKeyPath:ofObject:defaultValue: to persist
// values for keyPath of object.
- (NSString *)keyForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object {
	NSString *className = [NSString stringWithCString:class_getName(object.class) encoding:NSASCIIStringEncoding];
	return [NSString stringWithFormat:@"%@.%@", className, keyPath];
}

// Uses KVO to monitor changes to the specified keyPath and persist them.
// Loads the keyPath with the persisted value if one exists, or else the 
// specified defaultValue when called.  The existing value at the keyPath is 
// ignored and overwritten.
//
// Warning: The value is persisted using a key constructed by concatenating the 
// object's class name with the specified keyPath.  So if you pass two instances
// of the same class to this method with the same keyPath, the last setter
// called will dictate the persisted value for all instances.

- (void)persistKeyPath:(NSString *)keyPath ofObject:(NSObject *)object defaultValue:(id)defaultValue {
	
	id existingValue = [[NSUserDefaults standardUserDefaults] objectForKey:[self keyForKeyPath:keyPath ofObject:object]];

	if (!existingValue && defaultValue) {
		[self setValue:defaultValue forKey:[self keyForKeyPath:keyPath ofObject:object]];
		existingValue = defaultValue;
	}
	
	[object setValue:existingValue forKeyPath:keyPath];
	
	[object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setObject:[object valueForKeyPath:keyPath] forKey:[self keyForKeyPath:keyPath ofObject:object]];
}

- (void)setDate:(NSDate *)date forKey:(NSString *)key {
    [self setValue:[date iso8601FormattedString] forKey:key];
}

- (NSDate *)dateForKey:(NSString *)key {
    return [NSDate dateWithISO8601String:[self stringForKey:key]];
}

@end

@interface FixCategoryBugNSUserDefaults : NSObject {}
@end
@implementation FixCategoryBugNSUserDefaults
@end
