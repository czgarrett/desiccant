//
//  DTHTTPQuery.h
//  PortablePTO
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQuery.h"
#import "DTResultObjectParser.h"
#import "DTHTTPQueryOperation.h"

@protocol DTResultObjectParser;

@interface DTHTTPQuery : DTAsyncQuery {
	NSURL *url;
	NSObject <DTResultObjectParser> *parser;
	NSString *method;
	NSData *body;
//	DTHTTPQueryOperation *operation;	
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSObject <DTResultObjectParser> *parser;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSData *body;
//@property (nonatomic, retain) DTHTTPQueryOperation *operation;	

- (id)initWithURL:(NSURL *)newURL queryDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;
+ (id)queryWithURL:(NSURL *)url queryDelegate:(NSObject <DTAsyncQueryDelegate> *)delegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;

@end
