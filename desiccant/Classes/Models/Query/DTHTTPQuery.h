//
//  DTHTTPQuery.h
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQuery.h"

@protocol DTResultObjectParser;

@interface DTHTTPQuery : DTAsyncQuery {
	NSURL *url;
	NSObject <DTResultObjectParser> *parser;
	NSString *method;
	NSMutableData *body;
	NSDictionary *postParameters;
	NSString *postFileKey;
	NSData *postFileData;
	NSString *postFilePath;
	NSString *username;
	NSString *password;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSObject <DTResultObjectParser> *parser;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSMutableData *body;
@property (nonatomic, retain) NSDictionary *postParameters;
@property (nonatomic, retain) NSString *postFileKey;
@property (nonatomic, retain) NSData *postFileData;
@property (nonatomic, retain) NSString *postFilePath;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithURL:(NSURL *)newURL queryDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;
+ (id)queryWithURL:(NSURL *)url queryDelegate:(NSObject <DTAsyncQueryDelegate> *)delegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;

@end
