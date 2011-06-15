//
//  DTCaptcha.h
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTGoogleCaptcha;

@protocol DTGoogleCaptchaDelegate <NSObject>
- (void)captcha:(DTGoogleCaptcha *)theCaptcha willPostResponse:(NSString *)response;
- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response wasRejectedWithReplacementCaptcha:(BOOL)hasReplacement;
- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response didFailWithError:(NSError *)error;
- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response wasAcceptedReturningData:(NSData *)data;
@end

@interface DTGoogleCaptcha : NSObject {
	NSURL *baseURL;
	NSString *formActionURLString;
	NSString *imageURLString;
	NSMutableDictionary *parameters;
	id <DTGoogleCaptchaDelegate> delegate;
	BOOL isPostingResponse;
	BOOL isCancelled;
	NSURLConnection *connection;
	NSURLResponse *response;
	NSString *userResponse;
	NSMutableData *downloadedHTMLData;
	DTGoogleCaptcha *replacementCaptcha;
}

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSString *formActionURLString;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain, readonly) NSURL *imageURL;
@property (nonatomic, retain) NSMutableDictionary *parameters;
@property (nonatomic, assign) id <DTGoogleCaptchaDelegate> delegate;
@property (nonatomic, readonly) BOOL isPostingResponse;
@property (nonatomic, retain, readonly) NSURLConnection *connection;
@property (nonatomic, retain, readonly) NSURLResponse *response;
@property (nonatomic, retain, readonly) NSString *userResponse;
@property (nonatomic, readonly) BOOL isCancelled;

- (id)initWithHTMLData:(NSData *)theData returnedFromURL:(NSURL *)theBaseURL;
+ (id)captchaWithHTMLData:(NSData *)theData returnedFromURL:(NSURL *)theBaseURL;
- (void)postUserResponse:(NSString *)theUserResponse;
- (void)cancel;

@end
