//
//  DTSingleTextViewEditorViewController.h
//  ProLog
//
//  Created by Christopher Garrett on 10/8/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DTSingleTextViewEditorViewController;

@protocol DTSingleTextViewEditorViewControllerDelegate

- (void) editsWereSavedInSingleTextViewEditor: (DTSingleTextViewEditorViewController *) editor;

@end

@interface DTSingleTextViewEditorViewController : UIViewController {
   
   IBOutlet UITextView *textView;
   NSString *initialText;
   id <DTSingleTextViewEditorViewControllerDelegate> delegate;
   NSInteger tag;
   
}


@property (nonatomic, assign) id <DTSingleTextViewEditorViewControllerDelegate> delegate;
@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, assign) NSInteger tag;

@end
