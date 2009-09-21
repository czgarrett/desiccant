//
//  DTPListQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 9/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"


@interface DTPListQuery : DTAsyncQuery {
    NSString *fileName;
}

@property (nonatomic, retain) NSString *fileName;

- (id)initQueryWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryDelegate> *)aDelegate;
+ (DTPListQuery *)queryWithFileNamed:(NSString *)aFileName delegate:(NSObject <DTAsyncQueryDelegate> *)aDelegate;

@end
