//
//  DTPagedScrollView.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"
#import "DTPagedScrollViewDataSource.h"

@protocol DTPagedScrollViewDataSource;

@interface DTPagedScrollView : UIScrollView <UIScrollViewDelegate> {
    id<UIScrollViewDelegate> externalDelegate;
    NSInteger pageIndex;
    NSInteger _numberOfPages;
    NSObject<DTPagedScrollViewDataSource> *dataSource;
    BOOL shouldPassNonDragTouchEndEventsToNextResponder;
//    UIView *overlayView;
}

@property (nonatomic, readonly) NSInteger pageIndex;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic, retain) IBOutlet NSObject<DTPagedScrollViewDataSource> *dataSource;
@property (nonatomic) BOOL shouldPassNonDragTouchEndEventsToNextResponder;

//@property (nonatomic, retain, readonly) UIView *overlayView;

- (UIView *)focusedView;
- (void)showPageWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
