//
//  DTKeychain.h
//  BlueDevils
//
//  Created by Curtis Duhn on 4/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSingleton.h"

@interface DTKeychain : DTSingleton {
	NSString *defaultServiceName;
}

@property (nonatomic, retain) NSString *defaultServiceName;

+ (id)sharedKeychain;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key serviceName:(NSString *)serviceName;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key serviceName:(NSString *)serviceName;

@end
