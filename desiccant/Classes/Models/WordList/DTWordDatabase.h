//
//  DTWordDatabase.h
//  qatqi
//
//  Created by Garrett Christopher on 6/4/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTWordDatabase : NSObject

+ (DTWordDatabase *) instance;
+ (DTWordDatabase *) wordDatabase;

- (BOOL) containsWord: (NSString *) word;
- (BOOL) containsPartialWord: (NSString *) word;
- (NSString *) randomWordContainingPartial: (NSString *) partialWord;

@end
