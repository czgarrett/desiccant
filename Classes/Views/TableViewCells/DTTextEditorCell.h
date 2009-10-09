//
//  DTTextEditorCell.h
//  ProLog
//
//  Created by Christopher Garrett on 10/6/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTTextEditorCell : DTCustomTableViewCell {
   IBOutlet UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
