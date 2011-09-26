//
//  DTTitleAndImageCell.h
//  BlueDevils
//
//  Created by Curtis Duhn on 3/11/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTCustomTableViewCell.h"


@interface DTTitleAndImageCell : DTCustomTableViewCell {
	IBOutlet UIImageView *iconImageView;
	IBOutlet UILabel *titleLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
