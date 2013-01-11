//
//  ACXMLHTTPQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLHTTPQuery.h"
#import "DTHTTPXMLQueryOperation.h"

#pragma mark Private Interface
@interface DTXMLHTTPQuery ()
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) DTXMLParser *parser;
//@property (nonatomic, retain) DTHTTPXMLQueryOperation *operation;
@end

#pragma mark Implementation
@implementation DTXMLHTTPQuery

@synthesize 
url, parser, method, body, postParameters, postFileKey, postFileData, postFilePath; //, operation;

- (void)dealloc {
    self.url = nil;
    self.parser = nil;
//    self.operation = nil;
    self.method = nil;
    self.body = nil;
	self.postParameters = nil;
	self.postFileKey = nil;
	self.postFileData = nil;
	self.postFilePath = nil;
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate parser:(DTXMLParser *)newParser {
    if ((self = (DTXMLHTTPQuery *)[super initQueryWithDelegate:newDelegate])) {
        self.url = newURL;
        self.parser = newParser;
        self.method = @"GET";
        self.body = nil;
		self.postFileKey = nil;
		self.postFileData = nil;
		self.postFilePath = nil;
    }
    return self;
}

+ (id)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate parser:(DTXMLParser *)parser {
    return [[((DTXMLHTTPQuery *)[self alloc]) initWithURL:url delegate:delegate parser:parser] autorelease];
}

- (DTAsyncQueryOperation *)constructQueryOperation {
    DTHTTPXMLQueryOperation *newOperation = [DTHTTPXMLQueryOperation queryWithURL:url delegate:self parser:parser];
    newOperation.method = method;
    newOperation.body = body;
	newOperation.postParameters = postParameters;
	newOperation.postFileKey = postFileKey;
	newOperation.postFileData = postFileData;
	newOperation.postFilePath = postFilePath;	
    return newOperation;
}

@end
