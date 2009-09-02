//
//  DTRSSQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLHTTPQuery.h"

@interface DTRSSQuery : DTXMLHTTPQuery <DTTransformsUntypedData> {
}

+ (DTRSSQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate;

@end
