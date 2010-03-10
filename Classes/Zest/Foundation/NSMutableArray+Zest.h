//
//  NSArray+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSMutableArray ( Zest )

- (void) addObjectUnlessNil: (NSObject *) object;
- (id) pop;

@end
