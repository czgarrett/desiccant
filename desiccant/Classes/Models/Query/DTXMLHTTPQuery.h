//
//  ACXMLHTTPQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAsyncQuery.h"

@class DTHTTPXMLQueryOperation;
@class DTXMLParser;

// TODO: Refactor this to subclass DTHTTPQuery
@interface DTXMLHTTPQuery : DTAsyncQuery {
    NSURL *url;
    DTXMLParser *parser;
//    DTHTTPXMLQueryOperation *operation;
    NSString *method;
    NSMutableData *body;
	NSDictionary *postParameters;
	NSString *postFileKey;
	NSData *postFileData;
	NSString *postFilePath;	
}

- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate parser:(DTXMLParser *)parser;
+ (id)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate parser:(DTXMLParser *)parser;

@property (nonatomic, readonly, retain) NSURL *url;
@property (nonatomic, readonly, retain) DTXMLParser *parser;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSMutableData *body;
@property (nonatomic, retain) NSDictionary *postParameters;
@property (nonatomic, retain) NSString *postFileKey;
@property (nonatomic, retain) NSData *postFileData;
@property (nonatomic, retain) NSString *postFilePath;

@end
