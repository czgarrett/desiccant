//
//  NSArray+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray ( Zest )

// Returns a new array with the contents of this array in random order
// NOT cryptographically random
- (NSMutableArray *) shuffledArray;
- (NSString *)stringAtIndex:(NSUInteger)index;
- (NSDictionary *) dictionaryAtIndex:(NSUInteger)index;
- (BOOL) empty;
- (id) firstObject;
@end
