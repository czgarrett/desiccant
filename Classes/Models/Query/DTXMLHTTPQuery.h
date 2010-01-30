//
//  ACXMLHTTPQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/15/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTAsyncQuery.h"
#import "DTHTTPXMLQueryOperation.h"

@class DTHTTPXMLQueryOperation;

// TODO: Refactor this to subclass DTHTTPQuery
@interface DTXMLHTTPQuery : DTAsyncQuery {
    NSURL *url;
    DTXMLParser *parser;
//    DTHTTPXMLQueryOperation *operation;
    NSString *method;
    NSData *body;
}

- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate parser:(DTXMLParser *)parser;
+ (DTXMLHTTPQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate parser:(DTXMLParser *)parser;

@property (nonatomic, readonly, retain) NSURL *url;
@property (nonatomic, readonly, retain) DTXMLParser *parser;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSData *body;

@end
