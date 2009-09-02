//
//  DTXMLCollectionParser.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"

@interface DTXMLCollectionParserDelegate : DTXMLParserDelegate {
    NSObject *result;
    DTXMLParserDelegate *nestedParserDelegate;
}

@property (nonatomic, retain, readonly) NSObject *result;
@property (nonatomic, retain, readonly) NSMutableArray *rows;

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes
nestedParserDelegate:(DTXMLParserDelegate *)newNestedParserDelegate;
+ (DTXMLCollectionParserDelegate *)delegateWithElement:(NSString *)element nestedParserDelegate:(DTXMLParserDelegate *)nestedParserDelegate;

@end
