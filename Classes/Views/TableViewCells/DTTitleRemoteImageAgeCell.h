//
//  DTTitleRemoteImageAgeCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"
#import "DTImageView.h"

@interface DTTitleRemoteImageAgeCell : DTCustomTableViewCell {
    IBOutlet UILabel* title;
    IBOutlet UILabel* age;
    IBOutlet DTImageView* imageView;
}

@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* age;
@property (nonatomic, retain) IBOutlet DTImageView* imageView;

@end
