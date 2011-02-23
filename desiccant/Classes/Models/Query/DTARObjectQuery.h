//
//  DTARObjectQuery.h
//
//  Created by Curtis Duhn on 12/4/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAsyncQuery.h"

@interface DTARObjectQuery : DTAsyncQuery {
	Class arObjectClass;
}

@property (nonatomic, retain) Class arObjectClass;

- (id)initQueryWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate;
+ (id)queryWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate;

@end
