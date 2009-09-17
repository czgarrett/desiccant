//
//  DTPagedScrollViewDataSource.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTPagedScrollView.h"

@class DTPagedScrollView;

@protocol DTPagedScrollViewDataSource

- (UIView *)pagedScrollView:(DTPagedScrollView *)pagedScrollView viewForPageWithIndex:(NSInteger)index;
- (void)pagedScrollView:(DTPagedScrollView *)pagedScrollView recycleView:(UIView *)aView fromPageWithIndex:(NSInteger)index;
- (void)pagedScrollView:(DTPagedScrollView *)pagedScrollView didSwitchToPageWithIndex:(NSInteger)index view:(UIView *)view;

@end
