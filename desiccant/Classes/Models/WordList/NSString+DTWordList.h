//
//  NSString+DTWordList.h
//  desiccant
//
//  Created by Garrett Christopher on 6/8/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DTWordList)

- (BOOL) isWord;
// Returns YES if the the characters in the string are a portion of a full word.
// e.g. "dge" would return YES, since it is part of the word "edge"
- (BOOL) isPotentialWord;

@end
