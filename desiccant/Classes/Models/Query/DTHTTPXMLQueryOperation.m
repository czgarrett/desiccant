//
//  DTRSSQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPXMLQueryOperation.h"
#import "NSString+Zest.h"
#import "Zest.h"

#pragma mark Private Interface
@interface DTHTTPXMLQueryOperation()
@property (nonatomic, retain) DTXMLParser *parser;
@property (nonatomic, retain) NSArray *rows;
@end


#pragma mark Class Implementation
@implementation DTHTTPXMLQueryOperation
@synthesize rows, parser;

- (void)dealloc {
	self.parser = nil;
	self.rows = nil;
	
	[super dealloc];
}

- (DTHTTPXMLQueryOperation *)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate parser:(DTXMLParser *)newParser {
	if ((self = [super initWithURL:newURL delegate:newDelegate])) {
        self.parser = newParser;
    }
    return self;
}

+ (DTHTTPXMLQueryOperation *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate parser:(DTXMLParser *)parser {
    return [[(DTHTTPXMLQueryOperation *)[self alloc] initWithURL:url delegate:delegate parser:parser] autorelease];
}

- (void)prepareForQuery {
	[parser reset];
}
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [request addRequestHeader:field value:value];
} 

- (BOOL)parseResponseData {
	if ([parser parseXMLDataSuccessfully:responseData]) {
		self.rows = parser.rows;
		return YES;
	}
	else {
      DTLog(@"Invalid feed response");
      DTLog(@"%@", [NSString stringWithData: responseData encoding: NSUTF8StringEncoding]);
		self.error = @"Error parsing feed";
		return NO;
	}
}

@end
