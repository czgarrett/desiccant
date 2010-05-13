//
//  DTHTTPPListQuery.m
//
//  Created by Curtis Duhn on 12/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTHTTPPListQuery.h"
#import "DTHTTPPListQueryOperation.h"

@interface DTHTTPPListQuery()
@end

@implementation DTHTTPPListQuery

- (DTAsyncQueryOperation *)constructQueryOperation {
	DTHTTPStructuredResponseQueryOperation *newOperation = [DTHTTPPListQueryOperation queryWithURL:url delegate:self resultObjectParser:parser];
	newOperation.method = method;
	newOperation.body = body;
	newOperation.postParameters = postParameters;
	newOperation.postFileKey = postFileKey;
	newOperation.postFileData = postFileData;
	newOperation.postFilePath = postFilePath;
	return newOperation;
}

@end
