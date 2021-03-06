//
//  DTHTTPQueryOperation.m
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPQueryOperation.h"
#import "Zest.h"

#define LOG_HTTP_RESPONSES YES

#define ABORT_IF_CANCELLED \
	if ([self isCancelled]) { \
		[connection cancel]; \
		[self completeOperationWithError:NO]; \
		return; \
	}


@interface DTHTTPQueryOperation()
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableData *tempData;
@property (nonatomic, retain) NSURLConnection *connection;
- (void)startLoadingResponseData;
//- (void)loadResponseData;
@end

@implementation DTHTTPQueryOperation
@synthesize url, responseData, error, method, body, request, tempData, connection, postParameters, postFileKey, postFileData, postFilePath, username, password;

- (void)dealloc {
	self.url = nil;
	self.responseData = nil;
	self.tempData = nil;
	self.error = nil;
	self.method = nil;
	self.body = nil;
	self.request.delegate = nil;
	self.request = nil;
	self.connection = nil;
	self.postParameters = nil;
	self.postFileKey = nil;
	self.postFileData = nil;
	self.postFilePath = nil;
	self.username = nil;
	self.password = nil;
	
	[super dealloc];
}

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate {
	if ((self = [super initWithDelegate:theDelegate])) {
		self.url = theURL;
		self.method = @"GET";
	}
	return self;
}

+ (id)queryOperationWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate {
	return [[[self alloc] initWithURL:theURL delegate:theDelegate] autorelease];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	[request addRequestHeader:field value:value];
}

- (void)startQuery {
	[self prepareForQuery];
	[self startLoadingResponseData];
}

- (void)startLoadingResponseData {
	ABORT_IF_CANCELLED
	self.responseData = nil;
	self.error = nil;
	if ([self.method isEqual:@"POST"]) {
		ASIFormDataRequest *postRequest =  [ASIFormDataRequest requestWithURL:self.url];
      postRequest.validatesSecureCertificate = NO;
		[postRequest setRequestMethod:@"POST"];
		if (self.body) [postRequest setPostBody:self.body];
		if (self.postParameters) {
			for (NSString *key in postParameters) {
				[postRequest setPostValue:[postParameters stringForKey:key] forKey:key];
			}
		}
		if (self.postFileKey) {
			if (self.postFileData) {
				[postRequest setData:self.postFileData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:self.postFileKey];
			}
			else if (self.postFilePath) {
				[postRequest setFile:self.postFilePath forKey:self.postFileKey];
			}
			else {
				NSAssert (0, @"Set postFileKey withou postFileData or postFilePath");
			}
		}
		self.request = postRequest;
	}
	else {
		self.request = [ASIHTTPRequest requestWithURL:self.url];
		[self.request setRequestMethod:self.method];
	}
	
	if (self.username && self.password) {
		[self.request setUsername:self.username];
		[self.request setPassword:self.password];
	}
	[self.request setTimeOutSeconds:30];
	
	request.delegate = self;
   [self retain]; // released when request is done
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
	ABORT_IF_CANCELLED
	self.responseData = theRequest.responseData;
    if (LOG_HTTP_RESPONSES) {
        NSString *responseBodyText = [NSString stringWithCString:[[responseData nullTerminated] bytes] encoding:NSUTF8StringEncoding];
        DTLog(@"%@ %@\n\n%@", self.method, self.url.to_s, responseBodyText);
    }
	BOOL errorOccurredWhileParsing = ![self parseResponseData];
	if (errorOccurredWhileParsing) {
		NSLog(@"Error parsing response from URL: %@", url);
		NSLog(@"Response body:");
		NSLog(@"%@", self.responseData.to_s);
      self.error = self.responseData.to_s;
	}
	[self completeOperationWithError:errorOccurredWhileParsing];
   [self release];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest {
	ABORT_IF_CANCELLED
	self.error = @"Unable to connect to the server at this time.  Please try again later.  (error dthqo1)";
	[self completeOperationWithError:YES];
   [self release];
}

//- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response {
//	ABORT_IF_CANCELLED
//	self.tempData = [NSMutableData dataWithCapacity:MAX([response expectedContentLength], 4096)];
//}
//
//- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
//	ABORT_IF_CANCELLED
//	
//	[tempData appendData:data];
//}
//
//- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
//	ABORT_IF_CANCELLED
//	self.error = @"Unable to connect to the server at this time.  Please try again later.  (error dthqo1)";
//	[self completeOperationWithError:YES];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
//	ABORT_IF_CANCELLED
//	self.responseData = tempData;
//	DTLog(@"\n--- BEGIN RESPONSE ---\n%@\n--- END RESPONSE ---", [NSString stringWithUTF8String:[[responseData nullTerminated] bytes]]);
//	[self completeOperationWithError:![self parseResponseData]];
//}

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
//	//    DTLog(@"%@", [err localizedDescription]);
//	//    DTLog([NSString stringWithUTF8String:[xmlData bytes]]);
//}

- (void)prepareForQuery {
}

- (BOOL)parseResponseData {
	return NO;
}

@end
