//
//  DTKeychain.m
//
//  Created by Curtis Duhn.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTKeychain.h"
#import "SFHFKeychainUtils.h"
#import "Zest.h"

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

#pragma mark Private methods

@end
