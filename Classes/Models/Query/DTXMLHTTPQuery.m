//
//  ACXMLHTTPQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLHTTPQuery.h"

#pragma mark Private Interface
@interface DTXMLHTTPQuery ()
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) DTXMLParser *parser;
//@property (nonatomic, retain) DTHTTPXMLQueryOperation *operation;
@end

#pragma mark Implementation
@implementation DTXMLHTTPQuery

@synthesize 
url, parser, method, body; //, operation;

- (void)dealloc {
    self.url = nil;
    self.parser = nil;
//    self.operation = nil;
    self.method = nil;
    self.body = nil;
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate parser:(DTXMLParser *)newParser {
    if (self = (DTXMLHTTPQuery *)[super initQueryWithDelegate:newDelegate]) {
        self.url = newURL;
        self.parser = newParser;
        self.method = @"GET";
        self.body = nil;
    }
    return self;
}

+ (DTXMLHTTPQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate parser:(DTXMLParser *)parser {
    return [[((DTXMLHTTPQuery *)[self alloc]) initWithURL:url delegate:delegate parser:parser] autorelease];
}

- (DTAsyncQueryOperation *)constructQueryOperation {
    DTHTTPXMLQueryOperation *newOperation = [DTHTTPXMLQueryOperation queryWithURL:url delegate:self parser:parser];
    newOperation.method = method;
    newOperation.body = body;
    return newOperation;
}

@end
