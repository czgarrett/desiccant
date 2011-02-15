//
//  DTRSSCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/3/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"
#import "DTImageView.h"

@interface DTRSSCell : DTCustomTableViewCell {
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* descriptionLabel;
    IBOutlet UILabel* shortAgeLabel;
    IBOutlet DTImageView* imageEnclosureView;
}

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel* shortAgeLabel;
@property (nonatomic, retain) IBOutlet DTImageView* imageEnclosureView;

@end
