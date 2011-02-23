//
//  DTXMLObjectParserDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"


@interface DTXMLObjectParserDelegate : DTXMLParserDelegate {
    NSObject *result;
//    NSMutableDictionary *tempResult;
    NSMutableArray *nestedParserDelegates;
}

@property (nonatomic, retain, readonly) NSObject *result;

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes nestedParserDelegates:(NSArray *)newNestedDelegates;
+ (id)delegateWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes nestedParserDelegates:(NSArray *)newNestedDelegates;
+ (id)delegateWithElement:(NSString *)element nestedParserDelegates:(NSArray *)nestedDelegates;
- (void)addNestedParserDelegate:(DTXMLParserDelegate *)newDelegate;

@end
