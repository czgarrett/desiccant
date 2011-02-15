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
#import "DTHTTPQueryOperation.h"

@protocol DTAsyncQueryOperationDelegate;

@interface DTHTTPXMLQueryOperation : DTHTTPQueryOperation {
    DTXMLParser *parser;
    NSArray *rows;
}

@property (nonatomic, retain, readonly) DTXMLParser *parser;
@property (nonatomic, retain, readonly) NSArray *rows;

- (DTHTTPXMLQueryOperation *)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate parser:(DTXMLParser *)newParser;
+ (DTHTTPXMLQueryOperation *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryOperationDelegate> *)delegate parser:(DTXMLParser *)parser;

@end

#import "DTAsyncQueryOperationDelegate.h"
