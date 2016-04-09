//
//  DTImageView.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DTImageViewDelegate.h"

@protocol DTImageViewDelegate;

@interface DTImageView : UIImageView

@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, weak) IBOutlet NSObject <DTImageViewDelegate> *delegate;
@property (nonatomic) BOOL alwaysCacheToDisk;

- (void)loadFromURL:(NSURL *)url;

@end
