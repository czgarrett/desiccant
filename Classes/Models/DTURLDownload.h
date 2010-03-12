//
//  DTURLDownload.h
//  PortablePTO
//
//  Created by Curtis Duhn on 1/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTURLDownloadDelegate;

@interface DTURLDownload : NSObject {
	NSURLConnection *connection;
	<DTURLDownloadDelegate> delegate;
	NSURLRequest *request;
	NSURLResponse *response;
	NSString *destination;
	NSMutableData *tempData;
	NSInteger bytesReceived;
	NSError *error;
	BOOL isStarted;
	BOOL isCancelled;
	BOOL isFinished;
}

@property (nonatomic, assign) <DTURLDownloadDelegate> delegate;
@property (nonatomic, retain, readonly) NSURLRequest *request;
@property (nonatomic, retain, readonly) NSURLResponse *response;
@property (nonatomic, retain, readonly) NSString *destination;
@property (nonatomic, readonly) NSInteger bytesReceived;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, readonly) BOOL isStarted;
@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, readonly) BOOL isFinished;

+ (id)urlDownloadWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate;
- (id)initWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate;
- (void)start;
- (void)cancel;

@end

@protocol DTURLDownloadDelegate <NSObject>
@optional
- (void)urlDownloadDidBegin:(DTURLDownload *)theDownload;
- (NSURLRequest *)urlDownload:(DTURLDownload *)theDownload willSendRequest:(NSURLRequest *)theRequest redirectResponse:(NSURLResponse *)redirectResponse;
- (BOOL)urlDownload:(DTURLDownload *)theDownload canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (BOOL)urlDownloadShouldUseCredentialStorage:(DTURLDownload *)theDownload;
- (void)urlDownload:(DTURLDownload *)theDownload didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)urlDownload:(DTURLDownload *)theDownload didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)urlDownload:(DTURLDownload *)theDownload didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
- (void)urlDownload:(DTURLDownload *)theDownload didReceiveResponse:(NSURLResponse *)response;
- (void)urlDownload:(DTURLDownload *)theDownload didReceiveDataOfLength:(NSUInteger)length;
- (void)urlDownload:(DTURLDownload *)theDownload didCreateDestination:(NSString *)path;
- (void)urlDownloadDidFinish:(DTURLDownload *)theDownload;
- (void)urlDownload:(DTURLDownload *)theDownload didFailWithError:(NSError *)error;
@end
