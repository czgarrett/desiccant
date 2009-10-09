//
//  DTSingleFieldEditorViewController.m
//  ProLog
//
//  Created by Christopher Garrett on 10/7/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTSingleDateFieldEditorViewController.h"


@implementation DTSingleDateFieldEditorViewController

@synthesize datePicker, delegate, initialDate, tag;

- (void) savePressed: (id) source {
   [self.delegate editsWereSavedInSingleDateFieldEditor: self];
   [self.navigationController popViewControllerAnimated: YES];
}

- (void) cancelPressed: (id) source {
   [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) dateValueChanged: (id) source {
   
}

- (void) viewWillAppear: (BOOL) animated {
   [super viewWillAppear: animated];
   self.datePicker.date = self.initialDate;
}

- (void) viewDidLoad {
   [super viewDidLoad];
   UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelPressed:)];
   [self.navigationItem setLeftBarButtonItem: cancelButton animated: NO];
   UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(savePressed:)];
   [self.navigationItem setRightBarButtonItem: saveButton animated: NO];
   
}

- (void)dealloc {
    [super dealloc];
}



@end

