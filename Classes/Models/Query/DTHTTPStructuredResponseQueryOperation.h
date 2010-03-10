//
//  DTHTTPStructuredResponseQueryOperation.h
//  PortablePTO
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTResultObjectParser.h"
#import "DTHTTPQueryOperation.h"

@protocol DTResultObjectParser;



@interface DTHTTPStructuredResponseQueryOperation : DTHTTPQueryOperation {
	NSObject <DTResultObjectParser> *resultObjectParser;
	NSMutableArray *rows;	
	NSObject *dtParsedResultObject;
}

@property (nonatomic, retain) NSObject <DTResultObjectParser> *resultObjectParser;
@property (nonatomic, retain) NSMutableArray *rows;

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)resultObjectParser;
+ (id)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)resultObjectParser;

// Subclasses must implement this and return an array or dictionary that can be parsed by the resultObjectParser based on the resultData
- (NSObject *)resultObject;

@end
