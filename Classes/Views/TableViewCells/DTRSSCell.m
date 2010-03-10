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
    if (titleLabel && [data stringForKey:@"title"]) {
		titleLabel.text = [[data stringForKey:@"title"] stringByRemovingMarkupTags];
		[self adjustHeightForLabel:titleLabel];
	}
    if (descriptionLabel && [data stringForKey:@"description"]) {
		descriptionLabel.text = [[data stringForKey:@"description"] stringByRemovingMarkupTags];
		[self adjustHeightForLabel:descriptionLabel];
	}
    if (shortAgeLabel && [data objectForKey:@"pubDate"]) shortAgeLabel.text = [[data dateForKey:@"pubDate"] shortAgeString];
    if (imageEnclosureView && [data stringForKey:@"image_url"]) [imageEnclosureView loadFromURL:[data stringForKey:@"image_url"].to_url];
}

- (BOOL)hasDynamicHeight {
	return YES;
}

@end
