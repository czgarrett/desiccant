

@interface DTPageBrowserController : UIViewController <UIScrollViewDelegate> {
   IBOutlet UIScrollView *scrollView;
   IBOutlet UIPageControl *pageControl;
   IBOutlet UIActivityIndicatorView *activityIndicator;
   
   NSMutableArray *pageControllers;
   // To be used when scrolls originate from the UIPageControl
   BOOL pageControlUsed;
}

@property (nonatomic, retain) NSMutableArray *pageControllers;

- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(NSNumber *)page;

- (NSInteger) pageCount;

@end
