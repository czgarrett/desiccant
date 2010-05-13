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
//	NSLog(@"Adjusting cell for data:\n  title: '%@'\n  subtitle: '%@'", [data stringForKey:@"title"], [data stringForKey:@"description"]);
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
		//		NSLog(@"    BEFORE adjust description: cell.height = %f, cell.minHeight = %f, title.height = %f, title.y = %f, description.height = %f, description.y = %f",
		//			  self.height, self.minHeight, titleLabel.height, titleLabel.y, descriptionLabel.height, descriptionLabel.y);
		[self adjustHeightForLabel:descriptionLabel];
		//		NSLog(@"    AFTER  adjust description: cell.height = %f, cell.minHeight = %f, title.height = %f, title.y = %f, description.height = %f, description.y = %f",
		//			  self.height, self.minHeight, titleLabel.height, titleLabel.y, descriptionLabel.height, descriptionLabel.y);
	}
	if (titleLabel) {
//		NSLog(@"    BEFORE adjust title: cell.height = %f, cell.minHeight = %f, title.height = %f, title.y = %f, description.height = %f, description.y = %f",
//			  self.height, self.minHeight, titleLabel.height, titleLabel.y, descriptionLabel.height, descriptionLabel.y);
		[self adjustHeightForLabel:titleLabel];
//		NSLog(@"    AFTER  adjust title: cell.height = %f, cell.minHeight = %f, title.height = %f, title.y = %f, description.height = %f, description.y = %f",
//			  self.height, self.minHeight, titleLabel.height, titleLabel.y, descriptionLabel.height, descriptionLabel.y);
	}
}

- (BOOL)hasDynamicHeight {
	return YES;
}

@end
