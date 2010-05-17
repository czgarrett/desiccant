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
    if (titleLabel) {
		titleLabel.text = @"";
		NSString *title = [[data stringForKey:@"title"] stringByRemovingMarkupTags];
		if (title) titleLabel.text = title;
	}
    if (descriptionLabel) {
		descriptionLabel.text = @"";
		NSString *description = [[data stringForKey:@"description"] stringByRemovingMarkupTags];
		if (description) descriptionLabel.text = description;
	}
    if (shortAgeLabel) {
		shortAgeLabel.text = @"";
		NSString *shortAge = [[data dateForKey:@"pubDate"] shortAgeString];
		if (shortAge) shortAgeLabel.text = shortAge;
	}
    if (imageEnclosureView && [data stringForKey:@"image_url"]) [imageEnclosureView loadFromURL:[data stringForKey:@"image_url"].to_url];
	
	if (descriptionLabel) {
		[self adjustHeightForLabel:descriptionLabel];
		descriptionLabel.hidden = ([descriptionLabel.text length] == 0);
	}
	if (titleLabel) {
		[self adjustHeightForLabel:titleLabel];
		titleLabel.hidden = ([titleLabel.text length] == 0);
	}
	NSLog(@"Title Margin: %f - %f = %f for '%@'", self.bounds.size.height, titleLabel.bounds.size.height, self.bounds.size.height - titleLabel.bounds.size.height, titleLabel.text);
}

- (BOOL)hasDynamicHeight {
	return YES;
}

@end
