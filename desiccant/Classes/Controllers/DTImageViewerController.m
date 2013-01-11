//
//  DTImageViewerController.m
//
//  Created by Curtis Duhn on 10/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTImageViewerController.h"
#import "DTImageView.h"

@interface DTImageViewerController()
@property (nonatomic, retain) NSURL *_url;
- (BOOL)imageViewHasNorthSouthMargins;
- (BOOL)imageViewHasEastWestMargins;
- (void)adjustContentSizeAndFrameForZoom;
@end

@implementation DTImageViewerController
@synthesize imageView, scrollView, _url;

- (void)dealloc {
	self.imageView.delegate = nil;
    self.imageView = nil;
	self.scrollView.delegate = nil;
    self.scrollView = nil;
    self._url = nil;
    
    [super dealloc];
}

- (id)initWithURL:(NSURL *)theURL {
    if ((self = [super init])) {
        self._url = theURL;
    }
    return self;
}

+ (DTImageViewerController *)controllerWithURL:(NSURL *)theURL {
    return [[[self alloc] initWithURL:theURL] autorelease];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setCanCancelContentTouches:NO];
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.autoresizesSubviews = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    if (!imageView) self.imageView = [[[DTImageView alloc] initWithImage:nil] autorelease];
    imageView.delegate = self;
    if (_url) [imageView loadFromURL:_url];
    [self.activityIndicator startAnimating];
    if (!scrollView) self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delegate = self;
    scrollView.bouncesZoom = YES;
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    if (!scrollView.superview) [self.view addSubview:scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.bounds;
}

- (void)setUrl:(NSURL *)theURL {
    self._url = theURL;
    if (imageView && theURL) {
        [imageView loadFromURL:theURL];
        [self.activityIndicator startAnimating];
    }
}

- (NSURL *)url {
    return self._url;
}

- (void)imageViewDidFinishLoading:(DTImageView *)theImageView {
    [self.activityIndicator stopAnimating];
    [self adjustContentSizeAndFrameForZoom];
}

- (void)adjustContentSizeAndFrameForZoom {
    if (imageView.superview) [imageView removeFromSuperview];
    CGRect newFrame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    imageView.frame = newFrame;
    scrollView.contentSize = imageView.image.size;
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = MIN(self.view.bounds.size.width / imageView.image.size.width,  self.view.bounds.size.height / imageView.image.size.height);
    [scrollView zoomToRect:imageView.frame animated:NO];

    CGSize newContentSize;
    CGRect newImageViewFrame = imageView.frame;

    newContentSize.height = MAX(self.view.bounds.size.height, imageView.frame.size.height);
    newImageViewFrame.origin.y = (newContentSize.height - imageView.frame.size.height) / 2;
    newContentSize.width = MAX(self.view.bounds.size.width, imageView.frame.size.width);
    newImageViewFrame.origin.x = (newContentSize.width - imageView.frame.size.width) / 2;
    
    scrollView.contentSize = newContentSize;
    imageView.frame = newImageViewFrame;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [scrollView addSubview:imageView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self adjustContentSizeAndFrameForZoom];
}

- (BOOL)imageViewHasNorthSouthMargins {
    return imageView.frame.size.height < self.view.frame.size.height;
}

- (BOOL)imageViewHasEastWestMargins {
    return imageView.frame.size.width < self.view.frame.size.width;
}

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error {
    [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Image failed to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}

@end
