//
//  DTXMLAttributeParserDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"

@interface DTXMLAttributeParserDelegate : DTXMLParserDelegate {
    NSString *attribute;
    NSObject *result;
}

@property (nonatomic, retain) NSString *attribute;
@property (nonatomic, retain, readonly) NSObject *result;

+ (DTXMLAttributeParserDelegate *) delegateWithKey:(NSString *)key element:(NSString *)element attribute:(NSString *)attribute matchingAttributes:(NSDictionary *)matchingAttributes;

@end
