//
//  DTSingleton.h
//
//  Created by Curtis Duhn on 1/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

//// Use this class to create a singleton as follows:
////
//// 1. Create a subclass of DTSingleton
////
//// 2. Above your subclass implementation, declare a static global variable for it like this:
//
//static GizmoManager *sharedGizmoManager = nil;
//
//// 3. Add a factory class method called something like +sharedManager, or whatever name is appropriate, and return
////    the response from +loadedSingleton like this:
//
//+ (id)sharedManager {
//	return [self loadedSingleton];
//}
//
//// 4. Implement +staticSingleton and return a pointer to your static global variable like this:
//
//+ (NSObject **)staticSingleton {
//	return &sharedGizmoManager;
//}
//
//// 5. Implement a normal -init method to initialize your singleton.
//
//- (id)init {
//	if (self = [super init]) {
//		// Setup your instance variables
//	}
//	return self;
//}
// 
//// That's it.  Now there will only ever be one instance of your subclass.

@interface DTSingleton : NSObject {

}

// Lazy-loads the singleton if necessary and returns its value.  Call this from your factory class method and 
// return its value. 
+ (NSObject *)loadedSingleton;

// Subclasses must implement this and return a pointer to the static variable that references the singleton instance.
+ (NSObject **)staticSingleton;

@end
