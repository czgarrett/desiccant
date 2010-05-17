//
//  NSUserDefaults+Zest.h
//  BlueDevils
//
//  Created by Curtis Duhn on 5/5/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"


@interface NSUserDefaults (Zest) 

// Returns the key used by persistKeyPath:ofObject:defaultValue: to persist
// values for keyPath of object.
- (NSString *)keyForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object;

// Uses KVO to monitor changes to the specified keyPath and persist them.
// Loads the keyPath with the persisted value if one exists, or else the 
// specified defaultValue when called.  The existing value at the keyPath is 
// ignored and overwritten.
//
// Warning: The value is persisted using a key constructed by concatenating the 
// object's class name with the specified keyPath.  So if you pass two instances
// of the same class to this method with the same keyPath, the last setter
// called will dictate the persisted value for all instances.
- (void)persistKeyPath:(NSString *)keyPath ofObject:(NSObject *)object defaultValue:(id)defaultValue;	

@end
