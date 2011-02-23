//
//  DTImageViewerController.h
//
//  Created by Curtis Duhn on 10/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTImageViewDelegate.h"

@protocol DTImageViewDelegate;

@interface DTImageViewerController : UIViewController <DTImageViewDelegate, UIScrollViewDelegate> {
    IBOutlet DTImageView *imageView;
    IBOutlet UIScrollView *scrollView;
    NSURL *_url;
}

@property (nonatomic, retain) IBOutlet DTImageView *imageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSURL *url;

- (id)initWithURL:(NSURL *)theURL;
+ (DTImageViewerController *)controllerWithURL:(NSURL *)theURL;

@end
