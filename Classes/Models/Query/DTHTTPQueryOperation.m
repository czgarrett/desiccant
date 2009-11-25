//
//  DTHTTPQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPQueryOperation.h"


@interface DTHTTPQueryOperation()
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSMutableURLRequest *request;
- (void)loadResponseData;
@end

@implementation DTHTTPQueryOperation
@synthesize url, responseData, error, method, body, request;

- (void)dealloc {
	self.url = nil;
	self.responseData = nil;
	self.error = nil;
	self.method = nil;
	self.body = nil;
	self.request = nil;

	[super dealloc];
}

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate {
	if (self = [super initWithDelegate:theDelegate]) {
		self.url = theURL;
		self.request = [NSMutableURLRequest requestWithURL:self.url];
		request.timeoutInterval = 30;
		self.method = @"GET";
	}
	return self;
}

+ (DTHTTPQueryOperation *)queryOperationWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate] autorelease];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	[request setValue:value forHTTPHeaderField:field];
}

- (BOOL)executeQuery {
	[self prepareForQuery];
	[self loadResponseData];
	if (!responseData) return NO;
	return [self parseResponseData];
}

- (void)loadResponseData {
	//	self.xmlData = [NSData dataWithContentsOfURL:url];
	[request setHTTPMethod:self.method];
	if (self.body) [request setHTTPBody:self.body];
	NSURLResponse *response;
	NSError *err;
	self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if (!responseData) {
		self.error = @"Error downloading feed";
	}
	//    NSLog(@"%@", [err localizedDescription]);
	//    NSLog([NSString stringWithUTF8String:[xmlData bytes]]);
}

- (void)prepareForQuery {
}

- (BOOL)parseResponseData {
	return NO;
}

@end
