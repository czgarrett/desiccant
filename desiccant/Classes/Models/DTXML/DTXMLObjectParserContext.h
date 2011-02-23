//
//  DTXMLObjectParserContext.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserContext.h"

@interface DTXMLObjectParserContext : DTXMLParserContext {
    NSMutableDictionary *tempResult;
}

@property (nonatomic, retain) NSMutableDictionary *tempResult;

@end
