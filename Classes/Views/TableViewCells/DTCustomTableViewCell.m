//
//  DTCustomTableViewCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCustomTableViewCell.h"
#import "Zest.h"

@implementation DTCustomTableViewCell
@synthesize minHeight;

#ifndef __IPHONE_3_0
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
#else
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
#endif
                
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    if ([data stringForKey:@"title"]) {
#ifdef __IPHONE_3_0
        self.textLabel.text = [data stringForKey:@"title"];
#else
        self.text = [data stringForKey:@"title"];
#endif
    }
    if ([data stringForKey:@"image_name"]) {
#ifdef __IPHONE_3_0
        self.imageView.image = [UIImage imageNamed:[data stringForKey:@"image_name"]];
#else
        self.image = [UIImage imageNamed:[data stringForKey:@"image_name"]];        
#endif
    }
}


- (void)dealloc {
    [super dealloc];
}

- (void)adjustHeightForLabel:(UILabel *)label {
	NSAssert ([self hasDynamicHeight], @"If you're going to call adjustHeightForLabel:, you must override hasDynamicHeight and return YES.");
	if (minHeight == 0.0 || self.bounds.size.height < minHeight) minHeight = self.bounds.size.height;
	CGFloat margin = self.bounds.size.height - label.frame.size.height;
	CGFloat newLabelHeight = [label heightToFitText];
	CGFloat newCellHeight = newLabelHeight + margin;
	if (newCellHeight < minHeight) {
		newCellHeight = minHeight;
		newLabelHeight = minHeight - margin;
	}
	CGFloat newLabelY;
	if (([label autoresizingMask] & UIViewAutoresizingFlexibleTopMargin) && !([label autoresizingMask] & UIViewAutoresizingFlexibleBottomMargin)) {
		newLabelY = label.frame.origin.y - (newLabelHeight - label.frame.size.height);
	}
	else if (!([label autoresizingMask] & UIViewAutoresizingFlexibleTopMargin) && ([label autoresizingMask] & UIViewAutoresizingFlexibleBottomMargin)) {
		newLabelY = label.frame.origin.y;
	}
	else {
		NSAssert (0, @"To adjust the height of a label, it must have one flexible top or bottom margin, and one fixed.");
	}
	
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newCellHeight);
	label.frame = CGRectMake(label.frame.origin.x, newLabelY, label.frame.size.width, newLabelHeight);
}

// Subclasses should override this method and return YES if they modify the height of the cell in setData
- (BOOL)hasDynamicHeight {
	return NO;
}

@end
