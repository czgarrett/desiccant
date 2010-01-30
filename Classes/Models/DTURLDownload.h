//
//  DTURLDownload.h
//  PortablePTO
//
//  Created by Curtis Duhn on 1/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"

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
@property (nonatomic, retain, readonly) NSError *error;
@property (nonatomic, readonly) BOOL isStarted;
@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, readonly) BOOL isFinished;

+ (id)downloadWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate;
- (id)initWithRequest:(NSURLRequest *)theRequest destination:(NSString *)theDestination delegate:(id <DTURLDownloadDelegate>)theDelegate;
- (void)start;
- (void)cancel;

@end

@protocol DTURLDownloadDelegate <NSObject>
@optional
- (void)downloadDidBegin:(DTURLDownload *)theDownload;
- (NSURLRequest *)download:(DTURLDownload *)theDownload willSendRequest:(NSURLRequest *)theRequest redirectResponse:(NSURLResponse *)redirectResponse;
- (BOOL)download:(DTURLDownload *)theDownload canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (BOOL)downloadShouldUseCredentialStorage:(DTURLDownload *)theDownload;
- (void)download:(DTURLDownload *)theDownload didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)download:(DTURLDownload *)theDownload didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)download:(DTURLDownload *)theDownload didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
- (void)download:(DTURLDownload *)theDownload didReceiveResponse:(NSURLResponse *)response;
- (void)download:(DTURLDownload *)theDownload didReceiveDataOfLength:(NSUInteger)length;
- (void)download:(DTURLDownload *)theDownload didCreateDestination:(NSString *)path;
- (void)downloadDidFinish:(DTURLDownload *)theDownload;
- (void)download:(DTURLDownload *)theDownload didFailWithError:(NSError *)error;
@end
