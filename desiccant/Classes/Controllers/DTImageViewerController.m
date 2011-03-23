//
//  DTImageViewerController.m
//
//  Created by Curtis Duhn on 10/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTImageViewerController.h"


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
    if (!imageView) self.imageView = [[[DTImageView alloc] initWithImage:nil] autorelease];
    imageView.delegate = self;
    if (_url) [imageView loadFromURL:_url];
    if (!scrollView) self.scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
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
    }
}

- (NSURL *)url {
    return self._url;
}

- (void)imageViewDidFinishLoading:(DTImageView *)theImageView {
    if (imageView.superview) [imageView removeFromSuperview];
    CGRect newFrame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
//    newFrame.size.width = imageView.image.size.width;
//    newFrame.size.height = imageView.image.size.height;
//    newFrame.origin.x = (self.view.frame.size.width - imageView.image.size.width) / 2;
//    newFrame.origin.y = (self.view.frame.size.height - imageView.image.size.height) / 2;
////    newFrame.origin.x = 0;
////    newFrame.origin.y = 0;
    imageView.frame = newFrame;
    scrollView.contentSize = imageView.image.size;
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = MIN(self.view.frame.size.width / imageView.image.size.width,  self.view.frame.size.height / imageView.image.size.height);
    [scrollView zoomToRect:imageView.frame animated:NO];
    [self adjustContentSizeAndFrameForZoom];
    [scrollView addSubview:imageView];
}

- (void)adjustContentSizeAndFrameForZoom {
    CGSize newContentSize;
    CGRect newImageViewFrame = imageView.frame;

    newContentSize.height = MAX(self.view.frame.size.height, imageView.frame.size.height);
    newImageViewFrame.origin.y = (newContentSize.height - imageView.frame.size.height) / 2;
    newContentSize.width = MAX(self.view.frame.size.width, imageView.frame.size.width);
    newImageViewFrame.origin.x = (newContentSize.width - imageView.frame.size.width) / 2;
    
    scrollView.contentSize = newContentSize;
    imageView.frame = newImageViewFrame;
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
