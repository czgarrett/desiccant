//
//  DTHTTPQueryOperation.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPQueryOperation.h"

#define ABORT_IF_CANCELLED \
	if ([self isCancelled]) { \
		[connection cancel]; \
		[self completeOperationWithError:NO]; \
		return; \
	}


@interface DTHTTPQueryOperation()
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSMutableData *tempData;
@property (nonatomic, retain) NSURLConnection *connection;
- (void)startLoadingResponseData;
//- (void)loadResponseData;
@end

@implementation DTHTTPQueryOperation
@synthesize url, responseData, error, method, body, request, tempData, connection;

- (void)dealloc {
	self.url = nil;
	self.responseData = nil;
	self.tempData = nil;
	self.error = nil;
	self.method = nil;
	self.body = nil;
	self.request = nil;
	self.connection = nil;
	
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

- (void)startQuery {
	[self prepareForQuery];
	[self startLoadingResponseData];
}

- (void)startLoadingResponseData {
	ABORT_IF_CANCELLED
	self.responseData = nil;
	self.error = nil;
	[request setHTTPMethod:self.method];
	if (self.body) [request setHTTPBody:self.body];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response {
	ABORT_IF_CANCELLED
	self.tempData = [NSMutableData dataWithCapacity:MAX([response expectedContentLength], 4096)];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
	ABORT_IF_CANCELLED
	
	[tempData appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	ABORT_IF_CANCELLED
	self.error = @"Unable to connect to the server at this time.  Please try again later.  (error dthqo1)";
	[self completeOperationWithError:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	ABORT_IF_CANCELLED
	self.responseData = tempData;
	[self completeOperationWithError:![self parseResponseData]];
}

- (BOOL)isConcurrent {
	return YES;
}

//- (BOOL)executeQuery {
//	[self prepareForQuery];
//	[self loadResponseData];
//	if (!responseData) return NO;
//	return [self parseResponseData];
//}
//
//- (void)loadResponseData {
//	//	self.xmlData = [NSData dataWithContentsOfURL:url];
//	[request setHTTPMethod:self.method];
//	if (self.body) [request setHTTPBody:self.body];
//	NSURLResponse *response;
//	NSError *err;
//	self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//	if (!responseData) {
//		self.error = @"Unable to connect to the server at this time.  Please try again later.  (error dthqo1)";
//	}
//	//    NSLog(@"%@", [err localizedDescription]);
//	//    NSLog([NSString stringWithUTF8String:[xmlData bytes]]);
//}

- (void)prepareForQuery {
}

- (BOOL)parseResponseData {
	return NO;
}

@end
