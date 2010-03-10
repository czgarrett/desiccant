//
//  DTJSONQueryOperation.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTHTTPStructuredResponseQueryOperation.h"

@interface DTJSONQueryOperation : DTHTTPStructuredResponseQueryOperation {
}

+ (id)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryOperationDelegate> *)theDelegate resultObjectParser:(NSObject <DTResultObjectParser> *)theResultObjectParser;

@end
