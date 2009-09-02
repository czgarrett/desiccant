//
//  DTRSSQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/17/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAsyncQueryOperation.h"
#import "DTXMLParser.h"

@protocol DTAsyncQueryOperationDelegate;

@interface DTHTTPXMLQueryOperation : DTAsyncQueryOperation {
    NSURL *url;
    DTXMLParser *parser;
    NSData *xmlData;
    NSArray *rows;
    NSString *error;
    NSString *method;
    NSData *body;
    NSMutableURLRequest *request;
}

@property (nonatomic, retain, readonly) NSURL *url;
@property (nonatomic, retain, readonly) DTXMLParser *parser;
@property (nonatomic, retain, readonly) NSArray *rows;
@property (nonatomic, retain, readonly) NSString *error;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSData *body;

+ (DTHTTPXMLQueryOperation *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate parser:(DTXMLParser *)parser;
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

@end

#import "DTAsyncQueryOperationDelegate.h"
