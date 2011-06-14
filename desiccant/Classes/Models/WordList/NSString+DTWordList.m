//
//  NSString+DTWordList.m
//  desiccant
//
//  Created by Garrett Christopher on 6/8/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "NSString+DTWordList.h"
#import "DTWordList.h"

@implementation NSString (DTWordList)

- (BOOL) isWord {
   return [self length] > 1 && [[DTWordList sowpodsFull] containsWord: self];
}
- (BOOL) isPotentialWord {
   return [self length] > 1 && [[DTWordList sowpodsPartial] containsWord: self];
}


@end
