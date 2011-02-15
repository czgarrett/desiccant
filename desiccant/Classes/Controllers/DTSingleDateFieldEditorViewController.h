//
//  DTSingleFieldEditorViewController.h
//  ProLog
//
//  Created by Christopher Garrett on 10/7/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTSingleDateFieldEditorViewController;

@protocol DTSingleDateFieldEditorViewControllerDelegate

- (void) editsWereSavedInSingleDateFieldEditor: (DTSingleDateFieldEditorViewController *) editor;

@end

@interface DTSingleDateFieldEditorViewController : UIViewController {

   IBOutlet UIDatePicker *datePicker;
   NSDate *initialDate;
   id <DTSingleDateFieldEditorViewControllerDelegate> delegate;
   NSInteger tag;
   
}


@property (nonatomic, assign) id <DTSingleDateFieldEditorViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *initialDate;
@property (nonatomic, assign) NSInteger tag;

- (IBAction) dateValueChanged: (id) source;

@end
