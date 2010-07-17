
#import "DTCompositeViewController.h"

@interface DTPageBrowserController : DTCompositeViewController <UIScrollViewDelegate> {
   IBOutlet UIScrollView *scrollView;
   IBOutlet UIPageControl *pageControl;
   
   NSMutableDictionary *pages;
   
   // To be used when scrolls originate from the UIPageControl
   BOOL pageControlUsed;
   NSInteger currentPage;
}

@property (assign) NSInteger currentPage;

@property (nonatomic, retain) NSMutableDictionary *pages;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(NSNumber *)page;
- (DTViewController *) createControllerForPage: (NSInteger) page;

- (NSInteger) pageCount;


@end
