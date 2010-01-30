//
//  DTHTTPQueryOperation.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQueryOperation.h"


@interface DTHTTPQueryOperation : DTAsyncQueryOperation {
	NSURL *url;
	NSMutableData *tempData;
	NSData *responseData;
	NSString *error;
	NSString *method;
	NSData *body;
	NSMutableURLRequest *request;
	NSURLConnection *connection;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSData *body;

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate;
+ (DTHTTPQueryOperation *)queryOperationWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate;
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
// Subclasses may override this to prepare for the query before the HTTP request is issued.
- (void)prepareForQuery;
// Subclasses should override this to parse the response data and prepare to respond with rows
- (BOOL)parseResponseData;

@end
