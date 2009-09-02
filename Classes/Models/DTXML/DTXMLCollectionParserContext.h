//
//  DTXMLCollectionParserContext.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserContext.h"

@interface DTXMLCollectionParserContext : DTXMLParserContext {
    NSMutableArray *tempResults;
}

@property (nonatomic, retain) NSMutableArray *tempResults;

@end
