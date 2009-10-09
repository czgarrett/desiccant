//
//  DTDescriptionCellWithImageView.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTDescriptionCellWithImageView.h"
#import "Zest.h"

@implementation DTDescriptionCellWithImageView
@synthesize imageView, description;

- (void)dealloc {
    self.imageView = nil;
    self.description = nil;
    
    [super dealloc];
}

#ifndef __IPHONE_3_0
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
#else
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
#endif
                // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSMutableDictionary *)data {
    description.text = [data stringForKey:@"about"];
    imageView.image = [UIImage imageNamed:[data stringForKey:@"image_name"]];
    CGFloat margin = self.bounds.size.height - description.bounds.size.height;
    CGFloat newLabelHeight = [description.text sizeWithFont:description.font constrainedToSize:CGSizeMake(description.bounds.size.width, 9999.0) lineBreakMode:UILineBreakModeWordWrap].height;
    CGFloat newCellHeight = newLabelHeight + margin;
    if (newCellHeight > self.bounds.size.height) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newCellHeight);
        description.frame = CGRectMake(description.frame.origin.x, description.frame.origin.y, description.bounds.size.width, newLabelHeight);
    }
}



@end
