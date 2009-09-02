//
//  DTXMLParser.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserDelegate.h"

@interface DTXMLParser : NSObject {
    DTXMLParserDelegate *parserDelegate;
}

@property (retain, readonly) NSMutableArray *rows;

- (id) initWithParserDelegate:(DTXMLParserDelegate *)newParserDelegate;
+ (DTXMLParser *) parserWithParserDelegate:(DTXMLParserDelegate *)parserDelegate;
- (void) reset;
- (BOOL) parseXMLDataSuccessfully:(NSData *)xmlData;

@end
