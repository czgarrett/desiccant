//
//  DTCaptcha.m
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
- (NSURL *)captchaResponseURL;
- (NSString *)queryString;
@property (nonatomic) BOOL isPostingResponse;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *userResponse;
@property (nonatomic, retain) NSMutableData *htmlData;
@property (nonatomic) BOOL isCancelled;
@property (nonatomic, retain) DTGoogleCaptcha *replacementCaptcha;
@end

@implementation DTGoogleCaptcha
@synthesize baseURL, formActionURLString, imageURLString, parameters, delegate, isPostingResponse, connection, response, userResponse, htmlData, isCancelled, replacementCaptcha;

- (void)dealloc {
	self.connection = nil;
	self.baseURL = nil;
	self.formActionURLString = nil;
	self.imageURLString = nil;
	self.parameters = nil;
	self.delegate = nil;
	self.response = nil;
	self.userResponse = nil;
	self.htmlData = nil;
	self.replacementCaptcha = nil;
	
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

- (NSURL *)imageURL {
	NSAssert (imageURLString && baseURL, @"Don't have an image URL string and a base URL to build an image URL with.");
	return [NSURL URLWithString:imageURLString relativeToURL:baseURL];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
	self.htmlData = [NSMutableData dataWithCapacity:MAX([urlResponse expectedContentLength], 1024)];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[htmlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.isPostingResponse = NO;
	[delegate captcha:self response:userResponse didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.isPostingResponse = NO;
	BOOL replaced = [self parseData:htmlData];
	unless (replaced) {
		[delegate captcha:self response:userResponse wasAcceptedReturningData:htmlData];
	}
	else {
		[delegate captcha:self response:userResponse wasRejectedWithReplacementCaptcha:replaced];
	}
}

#pragma mark Private methods

- (BOOL)parseData:(NSData *)data {
	//	DTMarkupDocument *document = [DTMarkupDocument documentWithData:data];
	
	NSString *documentString = [NSString stringWithUTF8String:[[data nullTerminated] bytes]];
	unless (documentString) {
		return NO;
	}
	
	NSString *fragment = [documentString stringByMatching:@"(<td +id=\"viewport_td\">.*?</td>)" capture:1L];
	unless (fragment) {
		return NO;
	}
	
	self.formActionURLString = [fragment stringByMatching:@"action.*?=.*?[\"'](.+?)[\"']" capture:1L];
	unless (formActionURLString) {
		return NO;
	}
	
	self.imageURLString = [fragment stringByMatching:@"<img .*?src.*?=.*?[\"'](.+?)[\"']" capture:1L];
	unless (imageURLString) {
		return NO;
	}
	
	NSArray *inputTags = [fragment componentsMatchedByRegex:@"<input .*?>"];
	self.parameters = [NSMutableDictionary dictionaryWithCapacity:16];
	for (NSString *inputTag in inputTags) {
		if ([inputTag stringByMatching:@"(type.*?=.*?[\"']?hidden[\"']?[ \n>])" capture:1L]) {
			NSString *name = [inputTag stringByMatching:@"name *?= *?[\"']([^ \"']+?)[\"']" capture:1L];
			NSString *value = [inputTag stringByMatching:@"value *?= *?[\"']([^ \"']+?)[\"']" capture:1L];
			unless (name && value) {
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
	NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", formActionURLString, [self queryString]]];
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

@end
