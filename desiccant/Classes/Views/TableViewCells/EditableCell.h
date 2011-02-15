//
//  EditableCell.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/7/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableCell : UITableViewCell {
   UITextField *textField;
   NSIndexPath *indexPath;
}

@property(nonatomic, retain) UITextField *textField;
@property(nonatomic, retain) NSIndexPath *indexPath;;
@end
