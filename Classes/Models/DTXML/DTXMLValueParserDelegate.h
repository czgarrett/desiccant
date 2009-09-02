//
//  DTXMLValueParser.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"

@interface DTXMLValueParserDelegate : DTXMLParserDelegate {
//    NSMutableString *tempValue;
    NSObject *result;
}

@property (nonatomic, retain, readonly) NSObject *result;

@end
