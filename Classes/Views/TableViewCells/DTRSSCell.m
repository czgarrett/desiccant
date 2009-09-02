//
//  DTRSSCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTRSSCell.h"
#import "Zest.h"

@implementation DTRSSCell
@synthesize titleLabel, descriptionLabel, shortAgeLabel, imageEnclosureView;

- (void)dealloc {
    self.titleLabel = nil;
    self.descriptionLabel = nil;
    self.shortAgeLabel = nil;
    self.imageEnclosureView = nil;
    
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    if (titleLabel) titleLabel.text = [data stringForKey:@"title"];
    if (descriptionLabel) descriptionLabel.text = [data stringForKey:@"description"];
    if (shortAgeLabel) shortAgeLabel.text = [[data dateForKey:@"pubDate"] shortAgeString];
    if (imageEnclosureView) [imageEnclosureView loadFromURL:[data stringForKey:@"image_url"].to_url];
}

@end
