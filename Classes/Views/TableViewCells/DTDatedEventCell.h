//
//  ACDatedEventCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/18/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCustomTableViewCell.h"

@class DTDatedEventCell;

@interface DTDatedEventCell : DTCustomTableViewCell {
    IBOutlet UILabel *dayName;
    IBOutlet UILabel *dayNumber;
    IBOutlet UILabel *eventName;
}

@property (nonatomic, retain) IBOutlet UILabel *dayName;
@property (nonatomic, retain) IBOutlet UILabel *dayNumber;
@property (nonatomic, retain) IBOutlet UILabel *eventName;

@end
