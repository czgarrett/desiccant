//
//  DTXMLCollectionParserContext.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLCollectionParserContext.h"


@implementation DTXMLCollectionParserContext
@synthesize tempResults;

- (void)dealloc {
    self.tempResults = nil;
    
    [super dealloc];
}

@end
