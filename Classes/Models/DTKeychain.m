//
//  DTKeychain.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTKeychain.h"
#import "SFHFKeychainUtils.h"
#import "Zest.h"
#import <objc/runtime.h>

static DTKeychain *sharedKeychain = nil;

@interface DTKeychain()
@end

@implementation DTKeychain
@synthesize defaultServiceName;

#pragma mark Memory management
- (void)dealloc {
	self.defaultServiceName = nil;
    [super dealloc];
}

#pragma mark Constructors

- (id)init {
	if (self = [super init]) {
		self.defaultServiceName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
		unless (defaultServiceName) self.defaultServiceName = @"dtkeychain_default_service_name";
	}
	return self;
}

+ (id)sharedKeychain {
	return [self loadedSingleton];
}

+ (NSObject **)staticSingleton {
	return &sharedKeychain;
}

#pragma mark Public methods

- (void)setString:(NSString *)value forKey:(NSString *)key {
	return [self setString:value forKey:key serviceName:defaultServiceName];
}

- (void)setString:(NSString *)value forKey:(NSString *)key serviceName:(NSString *)serviceName {
	NSError *error;
	if (value){
		[SFHFKeychainUtils storeUsername:key andPassword:value forServiceName:serviceName updateExisting:YES error:&error];
		NSAssert (error == nil, @"Error storing value in keychain");
	}
	else {
		[SFHFKeychainUtils deleteItemForUsername:key andServiceName:serviceName error:&error];
	}
}

- (NSString *)stringForKey:(NSString *)key {
	return [self stringForKey:key serviceName:defaultServiceName];
}

- (NSString *)stringForKey:(NSString *)key serviceName:(NSString *)serviceName {
	NSError *error;
	NSString *value = [SFHFKeychainUtils getPasswordForUsername:key andServiceName:serviceName error:&error];
	return value;
}

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
// Note: This only works for string properties.
//
// Warning: The value is persisted using a key constructed by concatenating the 
// object's class name with the specified keyPath.  So if you pass two instances
// of the same class to this method with the same keyPath, the last setter
// called will dictate the persisted value for all instances.
- (void)persistKeyPath:(NSString *)keyPath ofObject:(NSObject *)object defaultValue:(NSString *)defaultValue {
	
	NSString *existingValue = [self stringForKey:[self keyForKeyPath:keyPath ofObject:object]];
	
	if (!existingValue && defaultValue) {
		[self setString:defaultValue forKey:[self keyForKeyPath:keyPath ofObject:object]];
		existingValue = defaultValue;
	}
	
	[object setValue:existingValue forKeyPath:keyPath];
	
	[object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self setString:[object valueForKeyPath:keyPath] forKey:[self keyForKeyPath:keyPath ofObject:object]];
}

#pragma mark Private methods

@end
