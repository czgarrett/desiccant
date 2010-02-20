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

- (id)initWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate;
+ (DTRSSQuery *)queryWithURL:(NSURL *)theURL delegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate;

// Subclasses may override this to add additional DTXMLParserDelegate subclasses to parse any custom children added to the RSS <item> element
- (NSArray *)extendedParserDelegatesForRSSItem;

@end
