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


@end
