//
//  DTTitleSubtitleCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCustomTableViewCell.h"

@interface DTTitleSubtitleCell : DTCustomTableViewCell {
    IBOutlet UILabel *title;
    IBOutlet UILabel *subtitle;
}

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *subtitle;

@end
