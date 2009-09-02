//
//  DTXMLParser.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLParser.h"

@interface DTXMLParser()
@property (nonatomic, retain) DTXMLParserDelegate *parserDelegate;
@end


@implementation DTXMLParser
@synthesize parserDelegate;

- (void) dealloc {
    [parserDelegate release];
    [super dealloc];
}

- (id) initWithParserDelegate:(DTXMLParserDelegate *)newParserDelegate {
    if (self = [super init]) {
        self.parserDelegate = newParserDelegate;
        [self reset];
    }
    return self;
}

+ (DTXMLParser *) parserWithParserDelegate:(DTXMLParserDelegate *)parserDelegate {
    return [[[self alloc] initWithParserDelegate:parserDelegate] autorelease];
}

- (void)reset {
    [parserDelegate initContextWithParent:nil];
}

- (BOOL) parseXMLDataSuccessfully:(NSData *)xmlData {
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:xmlData] autorelease];
	[xmlParser setDelegate:parserDelegate];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
    return [xmlParser parse];
}

- (NSMutableArray *)rows {
    return parserDelegate.rows;
}


@end
