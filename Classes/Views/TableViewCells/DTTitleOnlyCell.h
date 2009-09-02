//
//  ACNewsCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/25/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"

@interface DTTitleOnlyCell : DTCustomTableViewCell {
    IBOutlet UILabel *title;
}

@property (nonatomic, retain) IBOutlet UILabel *title;

@end
