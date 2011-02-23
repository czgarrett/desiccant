//
//  DTXMLValueParserContext.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserContext.h"

@interface DTXMLValueParserContext : DTXMLParserContext {
    NSMutableString *tempValue;
}

@property (nonatomic, retain) NSMutableString *tempValue;

@end
