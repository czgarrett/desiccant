//
//  DTSingleTextViewEditorViewController.m
//  ProLog
//
//  Created by Christopher Garrett on 10/8/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTSingleTextViewEditorViewController.h"


@implementation DTSingleTextViewEditorViewController

@synthesize textView, delegate, initialText, tag;

- (void) savePressed: (id) source {
   [self.delegate editsWereSavedInSingleTextViewEditor: self];
   [self.navigationController popViewControllerAnimated: YES];
}

- (void) cancelPressed: (id) source {
   [self.navigationController popViewControllerAnimated: YES];
}

- (void) viewWillAppear: (BOOL) animated {
   [super viewWillAppear: animated];
   self.textView.text = self.initialText;
}

- (void) viewDidLoad {
   [super viewDidLoad];
   UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelPressed:)];
   [self.navigationItem setLeftBarButtonItem: cancelButton animated: NO];
   UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(savePressed:)];
   [self.navigationItem setRightBarButtonItem: saveButton animated: NO];
   [cancelButton release];
   [saveButton release];
}

- (void)dealloc {
   [super dealloc];
}



@end
