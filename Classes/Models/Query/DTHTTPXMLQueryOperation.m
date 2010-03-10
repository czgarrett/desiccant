//
//  DTRSSQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPXMLQueryOperation.h"

#pragma mark Private Interface
@interface DTHTTPXMLQueryOperation()
- (void)loadXMLData;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSData *xmlData;
@property (nonatomic, retain) DTXMLParser *parser;
@property (nonatomic, retain) NSArray *rows;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSMutableURLRequest *request;
@end


#pragma mark Class Implementation
@implementation DTHTTPXMLQueryOperation
@synthesize 
    url, xmlData, rows, error, parser, method, body, request;

- (void)dealloc {
    [url release];
    [parser release];
    [xmlData release];
    [rows release];
    [error release];
    [method release];
    [body release];
    [request release];
    
    [super dealloc];
}

- (DTHTTPXMLQueryOperation *)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate parser:(DTXMLParser *)newParser {
    if (self = [super init]) {
        self.url = newURL;
        self.request = [NSMutableURLRequest requestWithURL:self.url];
        request.timeoutInterval = 30;
        self.delegate = newDelegate;
        self.parser = newParser;
        self.method = @"GET";
    }
    return self;
}

+ (DTHTTPXMLQueryOperation *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate parser:(DTXMLParser *)parser {
    return [[[self alloc] initWithURL:url delegate: delegate parser:parser] autorelease];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [request setValue:value forHTTPHeaderField:field];
} 

- (BOOL)executeQuery {
    [parser reset];
    [self loadXMLData];
    if (!xmlData) return NO;
    if ([parser parseXMLDataSuccessfully:xmlData]) {
        self.rows = parser.rows;
        return YES;
    }
    else {
        self.error = @"Error parsing feed";
        return NO;
    }
}

- (void)loadXMLData {
//	self.xmlData = [NSData dataWithContentsOfURL:url];
    [request setHTTPMethod:self.method];
    if (self.body) [request setHTTPBody:self.body];
    NSURLResponse *response;
    NSError *err;
    self.xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (!xmlData) {
        self.error = @"Error downloading feed";
    }
//    NSLog(@"%@", [err localizedDescription]);
//    NSLog([NSString stringWithUTF8String:[xmlData bytes]]);
}

@end
