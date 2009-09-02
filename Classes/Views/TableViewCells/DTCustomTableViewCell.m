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

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {

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
        self.text = [data stringForKey:@"title"];
    }
    if ([data stringForKey:@"image_name"]) {
        self.image = [UIImage imageNamed:[data stringForKey:@"image_name"]];
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
