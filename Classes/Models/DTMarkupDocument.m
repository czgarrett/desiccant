//
//  DTMarkupDocument.m
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTMarkupDocument.h"
#import "XPathQuery.h"
#import "Zest.h"
#import "RegexKitLite.h"

@interface DTMarkupDocument()
- (NSString *)parseXMLNamespaceFromData;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *namespacePrefix;
@property (nonatomic, retain) NSString *namespaceURI;
@end

@implementation DTMarkupDocument
@synthesize data, namespaceURI, namespacePrefix;

#pragma mark Memory management
- (void)dealloc {
	self.data = nil;
	self.namespaceURI = nil;
	self.namespacePrefix = nil;
	
    [super dealloc];
}

#pragma mark Constructors
- (id)initWithData:(NSData *)theData {
	if (self = [super init]) {
		self.data = theData;
		self.namespaceURI = [self parseXMLNamespaceFromData];
		self.namespacePrefix = @"node";
	}
	return self;
}

+ (id)documentWithData:(NSData *)theData {
	return [[[self alloc] initWithData:theData] autorelease];
}

#pragma mark Public methods

- (NSArray *)findHTMLNodes:(NSString *)xpath {
	return PerformHTMLXPathQuery(data, xpath, namespacePrefix, namespaceURI);
}

- (NSArray *)findXMLNodes:(NSString *)xpath {
	return PerformXMLXPathQuery(data, xpath, namespacePrefix, namespaceURI);
}

#pragma mark Private methdos

- (NSString *)parseXMLNamespaceFromData {
	NSString *documentString = [NSString stringWithUTF8String:[[data nullTerminated] bytes]];
	NSString *namespace = [documentString stringByMatching:@" +xmlns *= *[\"']([^\"']+)[\"']" capture:1L];
	return namespace;
}

@end
