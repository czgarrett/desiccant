//
//  DTQueryBuilderCell.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/13/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTQueryBuilderCell
@property (nonatomic, retain) IBOutlet UILabel *fieldLabel;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@end


@interface DTQueryBuilderCell : UITableViewCell <DTQueryBuilderCell> {
	IBOutlet UILabel *fieldLabel;
	IBOutlet UITextField *textField;
}

@end
