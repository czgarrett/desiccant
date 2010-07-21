//
//  SoapRequest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/3/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "SoapRequest.h"
#import "NSURL+Zest.h"

@implementation SoapRequest

@synthesize outFilePath;
@synthesize arguments;
@synthesize requestTemplate;
@synthesize url;
@synthesize outFile;
@synthesize currentRequest;
@synthesize contentType;

-(SoapRequest *)initWithTemplateNamed:(NSString *)templateName url: (NSString *)urlString outFileName: (NSString *)outFileName delegate: (id <OperationProgressDelegate>) myDelegate
{
   if (self = [super init]) {
      self.contentType = @"application/soap+xml; charset=utf-8";
		self.url = [NSURL URLWithString: urlString];
		delegate = myDelegate;
      
		NSString *XMLPath = [[NSBundle mainBundle] pathForResource: templateName ofType:@"xml" inDirectory:nil];
		self.requestTemplate = (NSString *)[NSString stringWithContentsOfFile: XMLPath encoding: NSUTF8StringEncoding error: nil];

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    	NSString *documentsDirectory = [paths objectAtIndex:0];
    	self.outFilePath = [documentsDirectory stringByAppendingFormat: @"/%@", outFileName];
		
		[[NSFileManager defaultManager] createFileAtPath: outFilePath contents: [NSData data] attributes: nil];
	}
	return self;	
}

-(void)dealloc
{
//   NSLog(@"dealloc for soap request");
	if (response) {
		[response release];
	}
   self.arguments = nil;
   self.outFilePath = nil;
   self.requestTemplate = nil;
   self.url = nil;
   self.outFile = nil;
   self.currentRequest = nil;
	[super dealloc];
}

-(void)main 
{
//	NSLog(@"Starting main method in SoapRequest with %d arguments: %@", [arguments count], arguments);
	if (currentRequest) {
		[currentRequest cancel];
	}
	switch ([arguments count]) {
		case 1:
			[self postWithData: [NSString stringWithFormat: requestTemplate, [arguments objectAtIndex: 0]]];
			break;
		case 2:
			[self postWithData: [NSString stringWithFormat: requestTemplate, [arguments objectAtIndex: 0], [arguments objectAtIndex: 1]]];
			break;
		case 3:
			[self postWithData: [NSString stringWithFormat: requestTemplate, 
                                                         [arguments objectAtIndex: 0], 
                                                         [arguments objectAtIndex: 1], 
                                                         [arguments objectAtIndex: 2]]];
			break;
		case 4:
			[self postWithData: [NSString stringWithFormat: requestTemplate, 
																		[arguments objectAtIndex: 0], 
																		[arguments objectAtIndex: 1], 
																		[arguments objectAtIndex: 2], 
																		[arguments objectAtIndex: 3]]];
			break;		
	}
}

-(BOOL)canBeHandled {
	return [url hostIsReachable] && [NSURLConnection canHandleRequest:[NSURLRequest requestWithURL: url]];
}

-(void)postWithData: (NSString *)bodyData
{
//	NSLog(@"Posting Request : %@", bodyData);		
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
	NSData *data = [NSData dataWithBytes: [bodyData UTF8String] length: [bodyData lengthOfBytesUsingEncoding: NSUTF8StringEncoding]];
	self.outFile = [NSFileHandle fileHandleForWritingAtPath: outFilePath];
	
	[request setHTTPBody: data];
	[request setHTTPMethod: @"POST"];
   if (self.contentType) {
      [request setValue: self.contentType forHTTPHeaderField: @"Content-Type"];
   }
   
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest: request delegate: self startImmediately: NO];
   // We do this because NSURLConnection would schedule from whatever the current thread is.  In our case
   // this thread will terminate at the end of this method, so we schedule the url connection on the main thread.
   [connection scheduleInRunLoop: [NSRunLoop mainRunLoop] forMode: NSDefaultRunLoopMode];
	[UIApplication sharedApplication].networkActivityIndicatorVisible++;
	[connection start];
   self.currentRequest = connection;
   [connection release];
   NSAssert(self.currentRequest, @"Connection could not be created");
//   NSLog(@"created request, updating delegate");
	[delegate operationUpdate: self progress: 0.0 message: @"Connecting..."];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   long long expectedLength=[response expectedContentLength];

   bytesReceived=bytesReceived+[data length];

	[outFile writeData: data];

   if (expectedLength != NSURLResponseUnknownLength) {
       // if the expected content length is
       // available, display percent complete
       float progress = bytesReceived / (float)expectedLength;
		NSString *message = [NSString stringWithFormat: @"%1.1f/%1.1f MB", bytesReceived / 1000000.0, expectedLength / 1000000.0];
		if (![self isCancelled]) {
			[delegate operationUpdate: self progress: progress message: message];
		}
   }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)newResponse
{
   [delegate operationUpdate: self progress: 0.0 message: @"Beginning Download..."];
    // reset the progress, this might be called multiple times
    bytesReceived=0;
 
    // retain the response to use later
    [self setResponse: newResponse];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//	NSLog(@"Done loading!");
	[UIApplication sharedApplication].networkActivityIndicatorVisible--;
	[outFile closeFile];
  	[delegate operationComplete: self]; 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//	NSLog(@"Connection failed with error: %@", error);
	[UIApplication sharedApplication].networkActivityIndicatorVisible--;
	[outFile closeFile];
	[delegate operation: self didFailWithError: error];
}

- (void)setResponse:(NSURLResponse *)newConnectionResponse
{
    [newConnectionResponse retain];
    [response release];
    response = newConnectionResponse;
}

- (void) cancel
{
	if (currentRequest) {
		[currentRequest cancel];
	}
   [super cancel];
}
  
@end
