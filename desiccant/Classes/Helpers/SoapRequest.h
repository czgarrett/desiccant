//
//  SoapRequest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "OperationProgressDelegate.h"

@interface SoapRequest : NSOperation {
	NSString *outFilePath;
   NSString *requestTemplate;
	NSArray *arguments;
	NSURL *url;
	NSFileHandle *outFile;
	NSURLConnection *currentRequest;

	id <OperationProgressDelegate> delegate;
	NSURLResponse *response;
	NSInteger bytesReceived;
   NSString *contentType;
}

@property (retain) NSString *contentType;
@property (retain) NSString *outFilePath;
@property (retain) NSArray *arguments;
@property (retain) NSString *requestTemplate;
@property (retain) NSURL *url;
@property (retain) NSFileHandle *outFile;
@property (retain) NSURLConnection *currentRequest;

-(SoapRequest *)initWithTemplateNamed:(NSString *)templateName url: (NSString *)urlString outFileName: (NSString *) outFileName delegate: (id <OperationProgressDelegate>) delegate;
-(BOOL)canBeHandled;
-(void)postWithData: (NSString *)data;
-(void)setResponse:(NSURLResponse *)newResponse;
-(void)main;

@end
