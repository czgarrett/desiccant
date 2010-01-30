//
//  DTAsyncQueryDelegate.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/16/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTAsyncQuery.h"

@protocol DTAsyncQueryDelegate

- (void)queryDidFinishLoading:(DTAsyncQuery *)query;
- (void)queryDidFailLoading:(DTAsyncQuery *)query;

@optional
- (void)queryWillStartLoading:(DTAsyncQuery *)query;
- (void)queryDidCancelLoading:(DTAsyncQuery *)query;

@end
