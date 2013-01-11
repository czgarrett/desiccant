//
//  DTSetDataBasedTableViewController.m
//  BlueDevils
//
//  Created by Curtis Duhn on 3/15/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTSetDataBasedTableViewController.h"
#import "Zest.h"

@interface DTSetDataBasedTableViewController()
@end

@implementation DTSetDataBasedTableViewController

//- (void)dealloc {
//    [super dealloc];
//}

#pragma mark DTCustomTableViewCellDelegate protocol methods

// Subclasses should override this and return YES if the title should be 
// resized to have variable height
- (BOOL)cellShouldResizeTitle:(DTCustomTableViewCell *)theCell {
	return NO;
}

// Subclasses should override this and return YES if the subtitle should be
// resized to have variable height
- (BOOL)cellShouldResizeSubtitle:(DTCustomTableViewCell *)theCell {
	return NO;
}

// Returns an image with the resource name returned from imageNameFromData: by
// default.  Subclasses can override this if they want to use something else
// for the image.
- (UIImage *)cell:(DTCustomTableViewCell *)theCell imageFromData:(NSDictionary *)data {
	return [UIImage imageNamed:[data stringForKey:[self imageNameKey]]];
}

- (UIImage *)cell:(DTCustomTableViewCell *)theCell highlightedImageFromData:(NSDictionary *)data {
	return [UIImage imageNamed:[data stringForKey:[self highlightedImageNameKey]]];
}

// Returns the value for the key "title" by default.  Subclasses can override
// this to use something else for the cell's title.
- (NSString *)cell:(DTCustomTableViewCell *)theCell titleFromData:(NSDictionary *)data {
	return [data stringForKey:[self titleKey]];
}

// Returns the value for the key "subtitle" by default.  Subclasses can override
// this to use something else for the cell's title.
- (NSString *)cell:(DTCustomTableViewCell *)theCell subtitleFromData:(NSDictionary *)data {
	return [data stringForKey:[self subtitleKey]];
}

// Returns a URL constructed using the value for the key "image_url" by default.  
// Subclasses can override this to use something else for the cell's image URL.
- (NSURL *)cell:(DTCustomTableViewCell *)theCell imageURLFromData:(NSDictionary *)data {
	return [data stringForKey:[self imageURLKey]].toURL;
}

// Returns the value for the key "image_name" by default.  Subclasses can override
// this to use something else for the image name.
//- (NSString *)cell:(DTCustomTableViewCell *)theCell imageNameFromData:(NSDictionary *)data {
//	return [data stringForKey:@"image_name"];
//}

- (NSString *)imageNameKey {
	return @"image_name";
}

- (NSString *)highlightedImageNameKey {
	return @"highlighted_image_name";
}

- (NSString *)titleKey {
	return @"title";
}

- (NSString *)subtitleKey {
	return @"subtitle";
}

- (NSString *)imageURLKey {
	return @"image_url";
}


@end
