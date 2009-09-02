//
//  DTXMLObjectParserContext.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLObjectParserContext.h"


@implementation DTXMLObjectParserContext
@synthesize tempResult;

- (void)dealloc {
    self.tempResult = nil;
    
    [super dealloc];
}

@end
