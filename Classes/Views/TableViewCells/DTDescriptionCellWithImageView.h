//
//  DTDescriptionCellWithImageView.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCustomTableViewCell.h"

@interface DTDescriptionCellWithImageView : DTCustomTableViewCell {
IBOutlet UIImageView *imageView;
IBOutlet UILabel *description;
}

@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UILabel *description;

@end
