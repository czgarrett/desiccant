//
//  DTImageView.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTImageViewDelegate.h"

@protocol DTImageViewDelegate;

@interface DTImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData *data;
    IBOutlet UIImage *defaultImage;
    IBOutlet NSObject <DTImageViewDelegate> *delegate;
}

@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, assign) IBOutlet NSObject <DTImageViewDelegate> *delegate;

- (void)loadFromURL:(NSURL *)url;

@end
