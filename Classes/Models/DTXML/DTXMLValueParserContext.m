//
//  DTXMLValueParserContext.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLValueParserContext.h"


@implementation DTXMLValueParserContext
@synthesize tempValue;

- (void)dealloc {
    self.tempValue = nil;
    
    [super dealloc];
}

@end
