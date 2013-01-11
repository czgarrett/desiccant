//
//  DTHTTPQueryOperation.h
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQueryOperation.h"

@class ASIHTTPRequest;

@interface DTHTTPQueryOperation : DTAsyncQueryOperation {
	NSURL *url;
	NSMutableData *tempData;
	NSData *responseData;
	NSString *error;
	NSString *method;
	NSMutableData *body;
	NSDictionary *postParameters;
	ASIHTTPRequest *request;
	NSURLConnection *connection;
	NSString *postFileKey;
	NSData *postFileData;
	NSString *postFilePath;
	NSString *username;
	NSString *password;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSMutableData *body;
@property (nonatomic, retain) NSDictionary *postParameters;
@property (nonatomic, retain) NSString *postFileKey;
@property (nonatomic, retain) NSData *postFileData;
@property (nonatomic, retain) NSString *postFilePath;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;


- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate;
+ (id)queryOperationWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate;
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
// Subclasses may override this to prepare for the query before the HTTP request is issued.
- (void)prepareForQuery;
// Subclasses should override this to parse the response data and prepare to respond with rows
- (BOOL)parseResponseData;

@end
