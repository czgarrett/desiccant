//
//  DTURLDownload.m
//  PortablePTO
//
//  Created by Curtis Duhn on 1/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTURLDownload.h"


@interface DTURLDownload()
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSMutableData *tempData;
@property (nonatomic) NSInteger bytesReceived;
@property (nonatomic, retain) NSError *error;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) BOOL isCancelled;
@property (nonatomic) BOOL isFinished;
- (void)start;
@end

@implementation DTURLDownload
@synthesize connection, delegate, request, response, destination, tempData, bytesReceived, error, isStarted, isCancelled, isFinished;

#pragma mark Memory management

- (void)dealloc {
	self.connection = nil;
	self.delegate = nil;
	self.request = nil;
	self.response = nil;
	self.tempData = nil;
	self.error = nil;
	
    [super dealloc];
}

#pragma mark Constructors
- (id)initWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate {
	if (self = [super init]) {
		self.request = theRequest;
		self.destination = theDestination;
		self.delegate = theDelegate;
	}
	return self;
}

+ (id)downloadWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate {
	return [[[self alloc] initWithRequest:theRequest destination:theDestination delegate:theDelegate] autorelease];
}

#pragma mark NSURLConnection delegate methods

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)theRequest redirectResponse:(NSURLResponse *)redirectResponse {
	if (!isCancelled && [delegate respondsToSelector:@selector(download:willSendRequest:redirectResponse:)]) {
		return [delegate download:self willSendRequest:theRequest redirectResponse:redirectResponse];
	}
	else return theRequest;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	if (!isCancelled && [delegate respondsToSelector:@selector(download:canAuthenticateAgainstProtectionSpace:)]) {
		return [delegate download:self canAuthenticateAgainstProtectionSpace:protectionSpace];
	}
	else return NO;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
	if (!isCancelled && [delegate respondsToSelector:@selector(downloadShouldUseCredentialStorage:)]) {
		return [delegate downloadShouldUseCredentialStorage:self];
	}
	else return YES;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	if (!isCancelled && [delegate respondsToSelector:@selector(download:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
		[delegate download:self didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if (!isCancelled && [delegate respondsToSelector:@selector(download:didReceiveAuthenticationChallenge:)]) {
		[delegate download:self didReceiveAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if (!isCancelled && [delegate respondsToSelector:@selector(download:didCancelAuthenticationChallenge:)]) {
		[delegate download:self didCancelAuthenticationChallenge:challenge];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse {
	self.tempData = [NSMutableData dataWithCapacity:MAX([response expectedContentLength], 4096)];
	self.bytesReceived = 0;
	self.response = theResponse;
	if (!isCancelled && [delegate respondsToSelector:@selector(download:didReceiveResponse:)]) {
		[delegate download:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	unless (self.isCancelled) {
		[tempData appendData:data];
		self.bytesReceived = bytesReceived + [data length];
		if ([delegate respondsToSelector:@selector(download:didReceiveDataOfLength:)]) {
			[delegate download:self didReceiveDataOfLength:[data length]];
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	unless (self.isCancelled) {
		if ([response httpError]) {
			self.error = [response httpError];
			self.isFinished = YES;
			if ([delegate respondsToSelector:@selector(download:didFailWithError:)]) {
				[delegate download:self didFailWithError:error];
			}
		}
		else {		
			[tempData writeToFile:destination atomically:YES];
			
			if ([delegate respondsToSelector:@selector(download:didCreateDestination:)]) {
				[delegate download:self didCreateDestination:destination];
			}

			self.isFinished = YES;
			if ([delegate respondsToSelector:@selector(downloadDidFinish:)]) {
				[delegate downloadDidFinish:self];
			}
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)theError {
	unless (self.isCancelled) {
		self.error = theError;
		self.isFinished = YES;
		if ([delegate respondsToSelector:@selector(download:didFailWithError:)]) {
			[delegate download:self didFailWithError:error];
		}
	}
}


#pragma mark Public methods
- (void)start {
	unless (self.isStarted) {
		self.isStarted = YES;
		if ([delegate respondsToSelector:@selector(downloadDidBegin:)]) {
			[delegate downloadDidBegin:self];
		}
		self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	}
}

- (void)cancel {
	unless (self.isFinished || self.isFinished || !self.isStarted) {
		self.isCancelled = YES;
		[connection cancel];
	}
}

@end
