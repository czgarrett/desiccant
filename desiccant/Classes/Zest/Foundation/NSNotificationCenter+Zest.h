//
//  NSNotificationCenter+Zest.h
//  desiccant
//
//  Created by Curtis Duhn on 5/30/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (Zest)

- (void)replaceObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender;

@end
