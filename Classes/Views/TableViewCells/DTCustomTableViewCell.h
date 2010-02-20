//
//  DTCustomTableViewCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCustomTableViewCell : UITableViewCell {
	CGFloat minHeight;
}

@property (nonatomic) CGFloat minHeight;

// Subclasses can override this to set fields given a dictionary
- (void)setData:(NSDictionary *)data;

// Subclasses can call this in setData after setting the contents of a label.  It will adjust the height of the label 
// and the cell to fit the text.  If you're going to use this, make sure you override hasDynamicHeight and return YES.
- (void)adjustHeightForLabel:(UILabel *)label;

// Subclasses should override this method and return YES if they modify the height of the cell in setData
- (BOOL)hasDynamicHeight;

@end
