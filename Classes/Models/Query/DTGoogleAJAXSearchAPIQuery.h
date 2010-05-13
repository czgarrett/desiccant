//
//  DTGoogleAJAXSearchAPIQuery.h
//
//  Created by Curtis Duhn on 2/2/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTJSONQuery.h"


@interface DTGoogleAJAXSearchAPIQuery : DTJSONQuery {
	NSString *queryType;
	NSString *queryFragment;
	NSString *paramString;
	NSInteger startIndex;
}

@property (nonatomic, retain) NSString *queryType;
@property (nonatomic, retain) NSString *queryFragment;
@property (nonatomic, retain) NSString *paramString;
@property (nonatomic) NSInteger startIndex;

- (id)initWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex queryDelegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate;
+ (id)queryWithType:(NSString *)theType paramString:(NSString *)theParamString fragment:(NSString *)theQueryFragment startIndex:(NSInteger)theStartIndex queryDelegate:(NSObject <DTAsyncQueryDelegate> *)theDelegate;

@end
