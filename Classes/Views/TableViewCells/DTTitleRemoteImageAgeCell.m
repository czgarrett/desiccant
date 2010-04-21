//
//  DTTitleRemoteImageAgeCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTitleRemoteImageAgeCell.h"
#import "Zest.h"

@implementation DTTitleRemoteImageAgeCell
@synthesize title, age;//, imageView;

- (void)dealloc {
    self.title = nil;
    self.age = nil;
//    self.imageView = nil;
    
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    self.title.text = [data stringForKey:@"title"];
    self.age.text = [[data dateForKey:@"pubDate"] shortAgeString];
	NSAssert ([self.imageView isKindOfClass:DTImageView.class], @"imageView must be a DTImageView when used with DTTitleRemoteImageAgeCell");
    [(DTImageView *)self.imageView loadFromURL:[data stringForKey:@"image_url"].to_url];
}

@end
