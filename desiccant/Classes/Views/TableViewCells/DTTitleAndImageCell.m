//
//  DTTitleAndImageCell.m
//  BlueDevils
//
//  Created by Curtis Duhn on 3/11/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTTitleAndImageCell.h"


@interface DTTitleAndImageCell()
@end

@implementation DTTitleAndImageCell
@synthesize titleLabel, iconImageView;

- (void)dealloc {
	self.titleLabel = nil;
	self.iconImageView = nil;
	
    [super dealloc];
}

//- (void)setData:(NSDictionary *)theData {
//	self.titleLabel.text = [theData stringForKey:@"title"];
//	self.iconImageView.image = [UIImage imageNamed:[theData stringForKey:@"image_file"]];
//}
//

@end
