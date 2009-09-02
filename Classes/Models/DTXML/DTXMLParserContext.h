//
//  DTXMLParserContext.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"

@class DTXMLParserDelegate;

@interface DTXMLParserContext : NSObject {
    BOOL insideTargetElement;
    DTXMLParserContext *parent;
    NSDictionary *attributes;
    NSInteger targetElementDepth;
    NSInteger parsingDepth;
    DTXMLParserDelegate *delegate;
}

@property (nonatomic, assign) BOOL insideTargetElement; 
@property (nonatomic, retain) DTXMLParserContext *parent;
@property (nonatomic, retain) DTXMLParserDelegate *delegate;
@property (nonatomic, retain) NSDictionary *attributes;
@property (nonatomic, assign) NSInteger targetElementDepth;
@property (nonatomic, assign) NSInteger parsingDepth;

- (id)initWithParent:(DTXMLParserContext *)newParent delegate:(DTXMLParserDelegate *)newDelegate;
+ (id)contextWithParent:(DTXMLParserContext *)parent delegate:(DTXMLParserDelegate *)delegate;

@end
