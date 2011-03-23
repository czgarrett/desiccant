//
//  DTXMLParser.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLParser.h"
#import "Zest.h"

@interface DTXMLParser()
@property (nonatomic, retain) DTXMLParserDelegate *parserDelegate;
@end


@implementation DTXMLParser
@synthesize parserDelegate, parserError;

- (void) dealloc {
	self.parserDelegate = nil;
	self.parserError = nil;
    [super dealloc];
}

- (id) initWithParserDelegate:(DTXMLParserDelegate *)newParserDelegate {
    if ((self = [super init])) {
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
	self.parserError = nil;
}

- (BOOL) parseXMLDataSuccessfully:(NSData *)xmlData {
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:xmlData] autorelease];
	[xmlParser setDelegate:parserDelegate];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
    BOOL success = [xmlParser parse];
	unless (success) self.parserError = [xmlParser parserError];
	return success;
}

- (NSMutableArray *)rows {
    return parserDelegate.rows;
}


@end
