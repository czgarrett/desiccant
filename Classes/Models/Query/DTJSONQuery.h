//
//  DTJSONQuery.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/20/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTResultObjectParser.h"
#import "DTJSONQueryOperation.h"

@interface DTJSONQuery : DTAsyncQuery {
	NSURL *url;
	NSObject <DTResultObjectParser> *parser;
	DTJSONQueryOperation *operation;	
	NSString *method;
	NSData *body;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSObject <DTResultObjectParser> *parser;
@property (nonatomic, retain) DTJSONQueryOperation *operation;	
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSData *body;

- (id)initWithURL:(NSURL *)newURL queryDelegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;
+ (DTJSONQuery *)queryWithURL:(NSURL *)url queryDelegate:(NSObject <DTAsyncQueryDelegate> *)delegate resultObjectParser:(NSObject <DTResultObjectParser> *)parser;

@end
