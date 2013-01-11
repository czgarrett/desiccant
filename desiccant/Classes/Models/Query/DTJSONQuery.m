//
//  DTJSONQuery.m
//
//  Created by Curtis Duhn on 11/20/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPQuery.h"
#import "DTJSONQuery.h"
#import "DTJSONQueryOperation.h"

@interface DTJSONQuery()
@end

@implementation DTJSONQuery

- (DTAsyncQueryOperation *)constructQueryOperation {
	DTJSONQueryOperation *newOperation = [DTJSONQueryOperation queryWithURL:url delegate:self resultObjectParser:parser];
	newOperation.method = method;
	newOperation.body = body;
	newOperation.postParameters = postParameters;
	newOperation.postFileKey = postFileKey;
	newOperation.postFileData = postFileData;
	newOperation.postFilePath = postFilePath;
	newOperation.username = username;
	newOperation.password = password;
	return newOperation;
}

@end
