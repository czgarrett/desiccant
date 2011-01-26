//
//  UIApplication+Zest.h
//  NoteToSelf
//
//  Created by Curtis Duhn on 7/21/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIApplication(Zest)

// Returns a string containing the version number from info.plist
+ (NSString *)versionNumberString;

// Returns the bundle name from info.plist
+ (NSString *)bundleName;

// Returns a string containing a number that uniquely identifies this build.
// Note: This number is not sequential, but it should always increase.  
// It's based on seconds since a given date.
+ (NSString *)buildNumberString;

- (void)bcompat_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

@end
