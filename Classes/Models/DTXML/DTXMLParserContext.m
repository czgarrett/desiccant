//
//  DTXMLParserContext.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLParserContext.h"

@implementation DTXMLParserContext
@synthesize insideTargetElement, parent, delegate, attributes, targetElementDepth, parsingDepth;

- (void)dealloc {
    self.parent = nil;
    self.attributes = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithParent:(DTXMLParserContext *)newParent delegate:(DTXMLParserDelegate *)newDelegate {
    if (self = [super init]) {
        self.parent = newParent;
        self.delegate = newDelegate;
        self.insideTargetElement = NO;
        self.targetElementDepth = -1;
        self.parsingDepth = 0;
    }
    return self;
}

+ (id)contextWithParent:(DTXMLParserContext *)parent delegate:(DTXMLParserDelegate *)delegate {
    return [[[self alloc] initWithParent:parent delegate:delegate] autorelease];
}

@end
