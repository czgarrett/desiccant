//
//  DTSingleTextFieldEditorViewController.m
//  ProLog
//
//  Created by Christopher Garrett on 10/6/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "DTSingleTextFieldEditorViewController.h"


@implementation DTSingleTextFieldEditorViewController

@synthesize placeholder, initialText, textField, delegate, tag;

- (void) configureCell: (DTCustomTableViewCell *)unconfiguredCell atIndexPath: (NSIndexPath *) indexPath {
   DTTextEditorCell *textCell = (DTTextEditorCell *) unconfiguredCell;
   textCell.textField.placeholder = self.placeholder;
   textCell.textField.text = self.initialText;
   
   [textCell.textField becomeFirstResponder];
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
   [self.delegate editsWereSavedInSingleTextFieldEditor: self];
   [self.navigationController popViewControllerAnimated: YES];   
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
   return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
   [theTextField endEditing: NO];
   return NO;
}

#pragma mark TableViewDataSourceDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return 1;
}

#pragma mark button support

- (void) cancelPressed: (id) source {
   [self.navigationController popViewControllerAnimated: YES];
}

- (void) savePressed: (id) source {
   [self.textField endEditing: NO];
}

#pragma mark lifecycle

- (void) viewDidLoad {
   [super viewDidLoad];
   self.cellNibName = @"DTTextEditorCell";
   UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelPressed:)];
   [self.navigationItem setLeftBarButtonItem: cancelButton animated: NO];
   UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(savePressed:)];
   [self.navigationItem setRightBarButtonItem: saveButton animated: NO];
}

@end
