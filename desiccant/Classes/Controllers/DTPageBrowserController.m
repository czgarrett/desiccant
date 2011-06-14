//
//  DTPageBrowserController.m
//  WordTower
//
//  Created by Christopher Garrett on 2/20/10.
//  Copyright 2010 ZWorkbench, Inc.. All rights reserved.
//

#import "DTPageBrowserController.h"
#import "Zest.h"

@implementation DTPageBrowserController

@synthesize pages, pageControl, scrollView, currentPage;

// Subclasses should override this
- (NSInteger) pageCount {
   return [self.pages count];
}

// Subclasses should override this
- (DTViewController *) createControllerForPage: (NSInteger) page {
   return nil;
}

- (void)loadScrollViewWithPage:(NSNumber *)pageNumber {
   NSInteger page = [pageNumber integerValue];
   if (page < 0) return;
   if (page >= [self pageCount]) return;
   
   // replace the placeholder if necessary
   DTViewController *controller = [self.pages objectForKey: pageNumber];
   if (controller == nil) {
      controller = [self createControllerForPage: page];
      [self addSubviewController: controller];
      [self.pages setObject: controller forKey: pageNumber];
   }
   
   // add the controller's view to the scroll view
   if (nil == controller.view.superview) {
      CGRect frame = scrollView.frame;
      frame.origin.x = frame.size.width * page;
      frame.origin.y = 0;
      controller.view.frame = frame;
      [controller viewWillAppear: NO];
      [scrollView addSubview:controller.view];
      [controller viewDidAppear: NO];
   }
}

#pragma mark UIScrollViewDelegate methods

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   pageControlUsed = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
   // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
   // which a scroll event generated from the user hitting the page control triggers updates from
   // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
   if (pageControlUsed) {
      // do nothing - the scroll was initiated from the page control, not the user dragging
      return;
   }
   // Switch the indicator when more than 50% of the previous/next page is visible
   CGFloat pageWidth = scrollView.frame.size.width;
   int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
   pageControl.currentPage = page;
   
   // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
   [self loadScrollViewWithPage: [NSNumber numberWithInteger: page]];
   [self loadScrollViewWithPage: [NSNumber numberWithInteger: page-1]];
   [self loadScrollViewWithPage: [NSNumber numberWithInteger: page+1]];
   //[self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page-1] afterDelay: 0.5];
   //[self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page+1] afterDelay: 0.5];
   
   // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma mark PageControl

- (IBAction)changePage:(id)sender {
   int page = pageControl.currentPage;
   // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
   [self loadScrollViewWithPage:[NSNumber numberWithInteger: page]];
   [self loadScrollViewWithPage:[NSNumber numberWithInteger: page-1]];
   [self loadScrollViewWithPage:[NSNumber numberWithInteger: page+1]];
//   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page-1] afterDelay: 0.5];
//   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page+1] afterDelay: 0.5];
   // update the scroll view to the appropriate page
   CGRect frame = scrollView.frame;
   frame.origin.x = frame.size.width * page;
   frame.origin.y = 0;
   [scrollView scrollRectToVisible:frame animated:YES];
   // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
   pageControlUsed = YES;
}

- (void) setCurrentPage:(NSInteger) page{
   currentPage = page;
   if (pageControl) {
      pageControl.currentPage = page;
   }
}

#pragma mark UIViewController methods


- (void) loadPages {
   scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self pageCount], scrollView.frame.size.height);
   pageControl.numberOfPages = [self pageCount];
   
   pageControl.currentPage = self.currentPage;
   [self changePage: nil];   
   pageControlUsed = NO;
   [self.activityIndicator stopAnimating];
}

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
   [self.activityIndicator startAnimating];
}

- (void) viewDidAppear:(BOOL)animated {
   [super viewDidAppear: animated];
   [self performSelector: @selector(loadPages) withObject: nil afterDelay: 0.1];
}

- (void) viewDidDisappear:(BOOL)animated {
   [super viewDidDisappear: animated];
}



- (void) viewDidLoad {
   [super viewDidLoad];
   self.pages = [NSMutableDictionary dictionary];
   pageControl.numberOfPages = 0;
}

- (void) viewDidUnload {
   [super viewDidUnload];
   self.pages = nil;
}



@end
