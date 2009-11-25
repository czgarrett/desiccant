//
//  DTJSONQueryOperation.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTHTTPQueryOperation.h"
#import "DTResultObjectParser.h"

@interface DTJSONQueryOperation : DTHTTPQueryOperation {
	NSObject <DTResultObjectParser> *resultObjectParser;
	NSMutableArray *rows;
}

@property (nonatomic, retain) NSObject <DTResultObjectParser> *resultObjectParser;
@property (nonatomic, retain) NSMutableArray *rows;

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)resultObjectParser;
+ (DTJSONQueryOperation *)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)resultObjectParser;

@end
