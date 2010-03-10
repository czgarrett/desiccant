//
//  DTCaptcha.m
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleCaptcha.h"
#import "Zest.h"
#import "RegexKitLite.h"

@interface DTGoogleCaptcha()
- (BOOL)parseData:(NSData *)data;
- (NSURLRequest *)captchaURLRequestWithUserResponse:(NSString *)theUserResponse;
- (BOOL)responseWasAccepted;
- (NSURL *)captchaResponseURL;
- (NSString *)queryString;
@property (nonatomic) BOOL isPostingResponse;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *userResponse;
@property (nonatomic, retain) NSMutableData *newHTMLData;
@property (nonatomic) BOOL isCancelled;
@end

@implementation DTGoogleCaptcha
@synthesize baseURL, formActionURLString, imageURLString, parameters, delegate, isPostingResponse, connection, response, userResponse, newHTMLData, isCancelled;

- (void)dealloc {
	self.connection = nil;
	self.baseURL = nil;
	self.formActionURLString = nil;
	self.imageURLString = nil;
	self.parameters = nil;
	self.delegate = nil;
	self.response = nil;
	self.userResponse = nil;
	self.newHTMLData = nil;
	
    [super dealloc];
}

- (id)initWithHTMLData:(NSData *)theData returnedFromURL:(NSURL *)theBaseURL {
	if (self = [super init]) {
		self.baseURL = theBaseURL;
		unless ([self parseData:theData]) {
			[self release];
			return nil;
		}
	}
	return self;
}

+ (id)captchaWithHTMLData:(NSData *)theData returnedFromURL:(NSURL *)theBaseURL {
	return [[[self alloc] initWithHTMLData:theData returnedFromURL:theBaseURL] autorelease];
}

- (void)postUserResponse:(NSString *)theUserResponse {
	self.userResponse = theUserResponse;
	self.isPostingResponse = YES;
	[delegate captcha:self willPostResponse:userResponse];
	self.connection = [NSURLConnection connectionWithRequest:[self captchaURLRequestWithUserResponse:userResponse] delegate:self];
}

- (void)cancel {
	if (self.isPostingResponse) {
		[connection cancel];
		self.isCancelled = YES;
		self.isPostingResponse = NO;
	}
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
	self.newHTMLData = [NSMutableData dataWithCapacity:[urlResponse expectedContentLength]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[newHTMLData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.isPostingResponse = NO;
	[delegate captcha:self response:userResponse didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.isPostingResponse = NO;
	if ([self responseWasAccepted]) {
		[delegate captcha:self responseWasAccepted:userResponse];
	}
	else {
		[delegate captcha:self response:userResponse wasRejectedWithReplacementCaptcha:[self parseData:newHTMLData]];
	}
}

#pragma mark Private methods

- (BOOL)parseData:(NSData *)data {
	//	DTMarkupDocument *document = [DTMarkupDocument documentWithData:data];
	
	NSString *documentString = [NSString stringWithUTF8String:[[data nullTerminated] bytes]];
	unless (documentString) {
		NSAssert (0, @"Couldn't convert data to string by treating it as UTF8");
		return NO;
	}
	
	NSString *fragment = [documentString stringByMatching:@"(<td +id=\"viewport_td\">.*?</td>)" capture:1L];
	unless (fragment) {
		NSAssert (0, @"Didn't find <td id=\"viewport_td\"> in captcha challenge");
		return NO;
	}
	
	self.formActionURLString = [fragment stringByMatching:@"action.*?=.*?[\"'](.+?)[\"']" capture:1L];
	unless (formActionURLString) {
		NSAssert1 (0, @"Couldn't find the form action in %@", fragment);
		return NO;
	}
	
	self.imageURLString = [fragment stringByMatching:@"<img .*?src.*?=.*?[\"'](.+?)[\"']" capture:1L];
	unless (imageURLString) {
		NSAssert1 (0, @"Couldn't find the image URL in %@", fragment);
		return NO;
	}
	
	NSArray *inputTags = [fragment componentsMatchedByRegex:@"<input .*?>"];
	self.parameters = [NSMutableDictionary dictionaryWithCapacity:16];
	for (NSString *inputTag in inputTags) {
		if ([inputTag stringByMatching:@"(type.*?=.*?[\"']?hidden[\"']?[ \n>])" capture:1L]) {
			NSString *name = [inputTag stringByMatching:@"name *?= *?[\"']([^ \"']+?)[\"']" capture:1L];
			NSString *value = [inputTag stringByMatching:@"value *?= *?[\"']([^ \"']+?)[\"']" capture:1L];
			unless (name && value) {
				NSAssert1 (0, @"Hidden input tag didn't have name and value: %@", inputTag);
				return NO;
			}
			[parameters setObject:value forKey:name];
		}
	}
	
	return YES;
}

- (NSURLRequest *)captchaURLRequestWithUserResponse:(NSString *)theUserResponse {
	NSURLRequest *myRequest = [NSURLRequest requestWithURL:[self captchaResponseURL]];
	return myRequest;
}

- (NSURL *)captchaResponseURL {
	NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", formActionURLString, [self queryString]]];
	return postURL;
}

- (NSString *)queryString {
	NSMutableString *myQueryString = [NSMutableString stringWithString:@"?"];
	for (NSString *key in parameters) {
		[myQueryString appendFormat:@"%@=%@&", key, [parameters stringForKey:key]];
	}
	[myQueryString appendFormat:@"captcha=%@", userResponse];
	return myQueryString;
}

- (BOOL)responseWasAccepted {
	return NO;
}

@end
