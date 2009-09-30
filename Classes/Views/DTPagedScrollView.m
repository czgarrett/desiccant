//
//  DTPagedScrollView.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DTPagedScrollView.h"


@interface DTPagedScrollView()
@property (nonatomic, assign) id<UIScrollViewDelegate> externalDelegate;
//@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic) NSInteger pageIndex;
- (void)preloadPageWithIndex:(NSInteger)index;
- (UIView *)leftNeighborView;
- (UIView *)rightNeighborView;
- (void)handlePageChange;
- (void)resizeContentViewToFitPages;
- (BOOL)subviewIsAPageNotAScrollingIndicator:(UIView *)subview;
- (CGSize)pageSize;
- (void)recyclePagesAboveIndex:(NSInteger)index;
- (void)recycleSubview:(UIView *)aView;
- (void)increaseNumberOfPagesIfNecessaryToFitPageWithIndex:(NSInteger)index;
- (CGRect)frameForPageIndex:(NSInteger)index;
@end

@implementation DTPagedScrollView
@synthesize externalDelegate, pageIndex, dataSource, shouldPassNonDragTouchEndEventsToNextResponder;

- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        [super setDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [dataSource release];
    
    [super dealloc];
}

- (NSInteger)numberOfPages {
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages {
    if (pages >= 0) {
        if (pages - 1 < pageIndex) [self showPageWithIndex:pages - 1 animated:NO];
        if (pages < _numberOfPages) [self recyclePagesAboveIndex:pages - 1];
        if (pages != _numberOfPages) {
            _numberOfPages = pages;
            [self resizeContentViewToFitPages];
        }
    }
}

- (void)resizeContentViewToFitPages {
    CGRect contentViewFrame = self.bounds;
    contentViewFrame.size.width = self.bounds.size.width * self.numberOfPages;
    self.contentSize = contentViewFrame.size;
}

- (void)showPageWithIndex:(NSInteger)index animated:(BOOL)animated {
    [self preloadPageWithIndex:index];
    [self setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:NO];
    [self handlePageChange];
}

- (void)increaseNumberOfPagesIfNecessaryToFitPageWithIndex:(NSInteger)index {
    if (self.numberOfPages < index + 1) self.numberOfPages = index + 1;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)newDelegate {
    [super setDelegate:self];
    self.externalDelegate = newDelegate;
}

- (id<UIScrollViewDelegate>)delegate {
    return self.externalDelegate;
}

- (CGRect)frameForPageIndex:(NSInteger)index {
    CGRect newFrame = self.bounds;
    // Note: The 1 pixel overlap on the following lines is a workaround needed because UIWebViews inside a 
    // scroll view don't render unless they're onscreen when loaded.
    newFrame.origin.x = index * self.bounds.size.width - 1;  // Offset by 1 to slightly overlap left neighbor
    newFrame.size.width += 2; // 2 pixels wider to also overlap right neighbor
    return newFrame;
}

- (UIView *)viewAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.numberOfPages) {
        for (UIView *aView in self.subviews) {
            CGRect subviewFrame = aView.frame;
            CGRect frameForIndex = [self frameForPageIndex:index];
            if (CGRectEqualToRect(subviewFrame, frameForIndex)) {
                return aView;
            }
        }
    }
    return nil;
}

- (void)preloadPageWithIndex:(NSInteger)index {
    [self increaseNumberOfPagesIfNecessaryToFitPageWithIndex:index];
    if (index >= 0 && index < self.numberOfPages && ![self viewAtIndex:index]) {
        UIView *newSubview = [dataSource pagedScrollView:self viewForPageWithIndex:index];
        newSubview.frame = [self frameForPageIndex:index];
        [self insertSubview:newSubview atIndex:0];
    }
}

- (void)preloadLeftNeighbor {
    [self preloadPageWithIndex:pageIndex - 1];
}

- (void)preloadRightNeighbor {
    [self preloadPageWithIndex:pageIndex + 1];
}

- (UIView *)leftNeighborView {
    return [self viewAtIndex:pageIndex - 1];
}

- (UIView *)focusedView {
    return [self viewAtIndex:pageIndex];
}

- (UIView *)rightNeighborView {
    return [self viewAtIndex:pageIndex + 1];
}

- (void)loadFocusedViewIfNecessary {
    if (![self focusedView]) {
        [self preloadPageWithIndex:pageIndex];
    }
}

- (void)preloadNeighboringViews {
    if (![self leftNeighborView] && pageIndex > 0) {
        [self preloadLeftNeighbor];
    }
    if (![self rightNeighborView] && pageIndex < self.numberOfPages - 1) {
        [self preloadRightNeighbor];
    }
}

- (NSInteger) indexForView:(UIView *)view {
    // adding 1 to x here because the frames for subviews are offset by 1 pixel to the left.
    return (NSInteger) (view.frame.origin.x + 1) / self.bounds.size.width;
}

- (void)recycleNonNeighboringViews {
    for (UIView *aView in self.subviews) {
        if ([self subviewIsAPageNotAScrollingIndicator:aView] && aView != [self leftNeighborView] && aView != [self focusedView] && aView != [self rightNeighborView]) {
            [self recycleSubview:aView];
        }
    }
}

- (void)recyclePagesAboveIndex:(NSInteger)index {
    for (UIView *aView in self.subviews) {
        if ([self subviewIsAPageNotAScrollingIndicator:aView] && [self indexForView:aView] > index) {
            [self recycleSubview:aView];
        }
    }
}

- (void)recycleSubview:(UIView *)aView {
    NSInteger index = [self indexForView:aView];
    [aView removeFromSuperview];
    [dataSource pagedScrollView:self recycleView:aView fromPageWithIndex:index];
}

- (BOOL)subviewIsAPageNotAScrollingIndicator:(UIView *)subview {
    return CGSizeEqualToSize([self pageSize], subview.frame.size);
}

- (CGSize)pageSize {
    CGSize size = self.bounds.size;
    size.width += 2;
    return size;
}

- (void)updatePageIndex {
    self.pageIndex = (NSInteger) self.contentOffset.x / self.bounds.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handlePageChange];
    if ([externalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [externalDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)handlePageChange {
    [self updatePageIndex];
    [self loadFocusedViewIfNecessary];
    [self recycleNonNeighboringViews];
    [self preloadNeighboringViews];
    [dataSource pagedScrollView:self didSwitchToPageWithIndex:[self pageIndex] view:[self focusedView]];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL aSelector = [invocation selector];
    
    if ([externalDelegate respondsToSelector:aSelector])
        [invocation invokeWithTarget:externalDelegate];
    else
        [self doesNotRecognizeSelector:aSelector];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if (!self.dragging) {
        if (self.shouldPassNonDragTouchEndEventsToNextResponder) {
            [[self nextResponder] touchesEnded:touches withEvent:event];
        }
    }
    [super touchesEnded:touches withEvent:event];
}


@end
