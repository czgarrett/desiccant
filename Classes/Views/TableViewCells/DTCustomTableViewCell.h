//
//  DTCustomTableViewCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCustomTableViewCell : UITableViewCell {
}


// Subclasses can override this to set fields given a dictionary
- (void)setData:(NSDictionary *)data;

@end
