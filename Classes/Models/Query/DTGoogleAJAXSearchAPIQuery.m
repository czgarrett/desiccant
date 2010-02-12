//
//  DTGoogleAJAXSearchAPIQuery.m
//  PortablePTO
//
//  Created by Curtis Duhn on 2/2/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleAJAXSearchAPIQuery.h"
#import "DTGoogleAJAXSearchAPIQueryOperation.h"
#import "DTGoogleAJAXSearchAPIParser.h"

@interface DTGoogleAJAXSearchAPIQuery()
- (NSURL *)urlWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex;
@property (nonatomic, retain, readonly) DTGoogleAJAXSearchAPIParser *googleParser;
@end

@implementation DTGoogleAJAXSearchAPIQuery
@synthesize queryType, queryFragment, startIndex, paramString;

#pragma mark Memory management

- (void)dealloc {
	self.queryType = nil;
	self.queryFragment = nil;
	self.paramString = nil;
	
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex queryDelegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate {
	if (self = [super initWithURL:[self urlWithType:theType paramString:theParamString fragment:theQueryFragment startIndex:theStartIndex] 
					queryDelegate:theDelegate 
			   resultObjectParser:[DTGoogleAJAXSearchAPIParser parser]])
	{
		self.queryType = theType;
		self.queryFragment = theQueryFragment;
		self.startIndex = theStartIndex;
		self.paramString = theParamString;
	}
	return self;
}

+ (id)queryWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex queryDelegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate {
	return [[[self alloc] initWithType:theType paramString:theParamString fragment:theQueryFragment startIndex:theStartIndex queryDelegate:theDelegate] autorelease];
}

#pragma mark DTAsyncQuery methods

- (DTAsyncQueryOperation *)constructQueryOperation {
	DTGoogleAJAXSearchAPIQueryOperation *newOperation = [DTGoogleAJAXSearchAPIQueryOperation queryWithURL:url delegate:self resultObjectParser:parser];
	newOperation.method = method;
	newOperation.body = body;
	return newOperation;
}

- (void)loadMoreResultsQuery {
	self.moreResultsQuery = nil;
	if ([self.googleParser hasMoreResults]) {
		self.moreResultsQuery = [DTGoogleAJAXSearchAPIQuery queryWithType:queryType paramString:paramString fragment:queryFragment startIndex:[self.googleParser nextStartIndex] queryDelegate:self];
	}
}

#pragma mark Private methods

- (NSURL *)urlWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex {
	NSString *startParameter = theStartIndex == 0 ? @"" : [NSString stringWithFormat:@"&start=%d", theStartIndex];
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/%@?v=1.0&rsz=large%@%@&q=%@", theType, theParamString, startParameter, theQueryFragment];
	return urlString.to_url;
}

#pragma mark Private dynamic properties

- (DTGoogleAJAXSearchAPIParser *)googleParser {
	return (DTGoogleAJAXSearchAPIParser *)self.parser;
}


@end
