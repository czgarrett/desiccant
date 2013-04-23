//
//  DTKeychain.h
//  BlueDevils
//
//  Created by Curtis Duhn on 4/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSingleton.h"

@interface DTKeychain : NSObject

@property (nonatomic, strong) NSString *defaultServiceName;

+ (id)sharedKeychain;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key serviceName:(NSString *)serviceName;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key serviceName:(NSString *)serviceName;

// Returns the key used by persistKeyPath:ofObject:defaultValue: to persist
// values for keyPath of object.
- (NSString *)keyForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object;
	
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
- (void)persistKeyPath:(NSString *)keyPath ofObject:(NSObject *)object defaultValue:(id)defaultValue;

@end
