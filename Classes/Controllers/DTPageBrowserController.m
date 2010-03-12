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

@synthesize pageControllers;

// Subclasses should override this
- (NSInteger) pageCount {
   return 0;
}

// Subclasses should override this
- (UIViewController *) createControllerForPage: (NSInteger) page {
   return nil;
}

- (void)loadScrollViewWithPage:(NSNumber *)pageNumber {
   NSInteger page = [pageNumber integerValue];
   if (page < 0) return;
   if (page >= [self pageCount]) return;
   
   // replace the placeholder if necessary
   UIViewController *controller = [self.pageControllers objectAtIndex:page];
   if ((NSNull *)controller == [NSNull null]) {
      controller = [self createControllerForPage: page];
      [self.pageControllers replaceObjectAtIndex:page withObject:controller];
   }
   
   // add the controller's view to the scroll view
   if (nil == controller.view.superview) {
      CGRect frame = scrollView.frame;
      frame.origin.x = frame.size.width * page;
      frame.origin.y = 0;
      controller.view.frame = frame;
      [controller viewWillAppear: YES];
      [scrollView addSubview:controller.view];
      [controller viewDidAppear: YES];
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
   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page-1] afterDelay: 0.5];
   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page+1] afterDelay: 0.5];
   
   // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma mark PageControl

- (IBAction)changePage:(id)sender {
   int page = pageControl.currentPage;
   // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
   [self loadScrollViewWithPage:[NSNumber numberWithInteger: page]];
   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page-1] afterDelay: 0.5];
   [self performSelector: @selector(loadScrollViewWithPage:) withObject: [NSNumber numberWithInteger: page+1] afterDelay: 0.5];
   // update the scroll view to the appropriate page
   CGRect frame = scrollView.frame;
   frame.origin.x = frame.size.width * page;
   frame.origin.y = 0;
   [scrollView scrollRectToVisible:frame animated:YES];
   // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
   pageControlUsed = YES;
}

#pragma mark UIViewController methods

- (void) viewWillAppear:(BOOL)animated {
   [super viewWillAppear: animated];
}

- (void) viewDidAppear:(BOOL)animated {
   [super viewDidAppear: animated];
   [self performSelector: @selector(loadPages) withObject: nil afterDelay: 0.1];
}

- (void) loadPages {
   LogTimeStart
   LogTime(@"DTPageBrowserController viewDidAppear 0");
   scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self pageCount], scrollView.frame.size.height);
   pageControl.numberOfPages = [self pageCount];
   pageControl.currentPage = 0;
   self.pageControllers = [NSMutableArray array];
   for (int i=0; i< [self pageCount]; i++) {
      [self.pageControllers addObject: [NSNull null]];
   }
   [self changePage: nil];   
   
   pageControlUsed = NO;
   for (UIViewController *controller in self.pageControllers) {
      if ((NSNull *)controller != [NSNull null]) {
         [controller viewWillAppear: NO];
      }
   }
   [activityIndicator stopAnimating];
   LogTime(@"DTPageBrowserController viewDidAppear 100");   
}

- (void) viewDidDisappear:(BOOL)animated {
   [super viewDidDisappear: animated];
   self.pageControllers = nil;
}

- (void) viewDidLoad {
   [super viewDidLoad];
   pageControl.numberOfPages = 0;
}

- (void) dealloc {
   self.pageControllers = nil;
   [super dealloc];
}


@end
