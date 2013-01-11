//
//  NSNotificationCenter+Zest.m
//  desiccant
//
//  Created by Curtis Duhn on 5/30/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSNotificationCenter+Zest.h"


@implementation NSNotificationCenter (Zest)

- (void)replaceObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender 
{
    [self removeObserver:notificationObserver name:notificationName object:notificationSender];
    [self addObserver:notificationObserver selector:notificationSelector name:notificationName object:notificationSender];
}

@end
