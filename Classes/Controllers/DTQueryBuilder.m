//
//  DTQueryBuilder.m
//  PortablePTO
//
//  Created by Curtis Duhn on 11/2/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTQueryBuilder.h"
#import "Zest.h"

@interface DTQueryBuilder()
- (BOOL)presentsNewInputCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)initPickerView;
- (void)initTextEditView;
- (void)scrollPickerViewPastTypesThatCanNotStartWithText:(NSString *)text;
- (NSObject <DTQueryBuilderElementType> *)selectedType;
- (void)updateRowMetadata;
- (BOOL)checkShouldShowNewInputCell;
- (void)animateRowChanges;
- (BOOL) isEditingNewInput;
- (void) startEditingSelectedElement;
@end

@implementation DTQueryBuilder
@synthesize queryBuilderDelegate, pickerView, textEditView, textEditField, elementBeingEdited, indexOfElementBeingEdited;
@synthesize textEditFieldLeftMargin, textEditFieldRightMargin, textEditFieldHeight, cancelButton, cancelButtonWidth;
@synthesize cancelButtonRightMargin, pickerViewRowHeight, pickerViewRowWidth, pickerViewLeftMargin, pickerViewRightMargin, candidateTypes, shouldShowNewInputCell;

- (void)dealloc {
	self.queryBuilderDelegate = nil;
	self.pickerView = nil;
	self.textEditView = nil;
	self.textEditField = nil;
	self.elementBeingEdited = nil;
	self.cancelButton = nil;
	self.candidateTypes = nil;
	
	[super dealloc];
}

- (id)initWithQueryBuilderDelegate:(NSObject <DTQueryBuilderDelegate> *)theDelegate {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.queryBuilderDelegate = theDelegate;
	}
	return self;
}

+ (DTQueryBuilder *)builderWithDelegate:(NSObject <DTQueryBuilderDelegate> *)theDelegate {
	return [[[self alloc] initWithQueryBuilderDelegate:theDelegate] autorelease];
}

- (void)viewDidLoad {
	self.textEditFieldLeftMargin = 10.0;
	self.textEditFieldRightMargin = 10.0;
	self.textEditFieldHeight = 32.0;
	self.cancelButtonWidth = 70.0;
	self.cancelButtonRightMargin = 10.0;
	self.pickerViewRowHeight = 40.0;
	self.pickerViewRowWidth = 290.0;
	self.pickerViewLeftMargin = 30.0;
	self.pickerViewRightMargin = 10.0;
	[self initPickerView];
	[self initTextEditView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
	[super viewDidLoad];
	self.tableView.editing = YES;
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

//- (void)beforeViewDidLoad:(UITableView *)theTableView {
//	self.textEditFieldLeftMargin = 10.0;
//	self.textEditFieldRightMargin = 10.0;
//	self.textEditFieldHeight = 32.0;
//	self.cancelButtonWidth = 70.0;
//	self.cancelButtonRightMargin = 10.0;
//	self.pickerViewRowHeight = 40.0;
//	self.pickerViewRowWidth = 290.0;
//	self.pickerViewLeftMargin = 30.0;
//	self.pickerViewRightMargin = 10.0;
//	[super beforeViewDidLoad:theTableView];
//	[self initPickerView];
//	[self initTextEditView];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
////	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
//}

//- (void)afterViewDidLoad:(UITableView *)theTableView {
//	self.tableView.editing = YES;
//}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	[self updateRowMetadata];
	if (shouldShowNewInputCell) return numberOfElements + 1;
	else return numberOfElements;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell <DTQueryBuilderCell> *newCell;
	if ([self presentsNewInputCellAtIndexPath:indexPath]) {
		newCell = [queryBuilderDelegate queryBuilder:self newInputCellForTableView:self.tableView];
	}
	else {
		NSObject <DTQueryBuilderElement> *element = [queryBuilderDelegate queryBuilder:self elementAtIndex:indexPath.row];
		newCell = [queryBuilderDelegate queryBuilder:self tableView:self.tableView cellForQueryElement:element];
	}
	newCell.textField.delegate = self;
	return newCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[queryBuilderDelegate queryBuilder:self deleteElementAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		self.indexOfElementBeingEdited = indexPath.row;
		[self startEditingSelectedElement];
	}
}

#pragma mark UITableViewDelegate methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (numberOfElements == 1 && !shouldShowNewInputCell) {
		return NO;
	}
	else {
		return YES;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self presentsNewInputCellAtIndexPath:indexPath]) {
		return UITableViewCellEditingStyleInsert;
	}
	else {
		return UITableViewCellEditingStyleDelete;
	}
}



#pragma mark UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [candidateTypes count];
}

#pragma mark UIPickerViewDelegate methods

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return pickerViewRowHeight;
}

- (CGFloat)pickerView:(UIPickerView *)thePickerView widthForComponent:(NSInteger)component {
	return pickerViewRowWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	DTQueryBuilderElementType *type = [candidateTypes objectAtIndex:row];
	UILabel *label = [UILabel labelWithText:type.selectorText];
	label.frame = CGRectMake(pickerViewLeftMargin, 0.0, pickerViewRowWidth - pickerViewLeftMargin - pickerViewRightMargin, pickerViewRowHeight);
	label.font = [UIFont boldSystemFontOfSize:18.0];
	if (![queryBuilderDelegate respondsToSelector:@selector(queryBuilder:type:isValidForText:atIndex:)] ||
		 [queryBuilderDelegate queryBuilder:self type:type isValidForText:textEditField.text atIndex:indexOfElementBeingEdited]) {
		label.textColor = [UIColor blackColor];
	}
	else {
		label.textColor = [UIColor grayColor];
	}
	label.backgroundColor = [UIColor transparentColor];
	UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, pickerViewRowWidth, pickerViewRowHeight)] autorelease];
	[container addSubview:label];
	return container;
}

#pragma mark Keyboard Notification methods
- (void) keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardBounds;
	[[[notification userInfo] valueForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardBounds];
	CGRect textEditFrame = textEditView.frame;
	textEditFrame.origin.y = pickerView.bounds.size.height;
	textEditFrame.size.height = 480.0 - keyboardBounds.size.height - pickerView.bounds.size.height;
	textEditView.frame = textEditFrame;
//	[[[UIApplication sharedApplication] keyWindow] addSubview:textEditView];
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == textEditField) {
		return YES;
	}
	else {
		self.indexOfElementBeingEdited = [self.tableView indexPathForCell:textField.tableViewCell].row;
		[self startEditingSelectedElement];		
		return NO;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[textField.window addSubview:pickerView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[pickerView removeFromSuperview];
	[textEditView removeFromSuperview];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[pickerView reloadComponent:0];
	NSMutableString *newText = [NSMutableString stringWithString:textField.text];
	[newText replaceCharactersInRange:range withString:string];
	[self scrollPickerViewPastTypesThatCanNotStartWithText:newText];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ((![queryBuilderDelegate respondsToSelector:@selector(queryBuilder:type:isValidForText:atIndex:)] ||
		  [queryBuilderDelegate queryBuilder:self 
												 type:[self selectedType] 
									isValidForText:textField.text
											 atIndex:indexOfElementBeingEdited]) &&
		 [queryBuilderDelegate queryBuilder:self 
			  didFinishEditingElementAtIndex:indexOfElementBeingEdited 
											withText:textField.text 
												 type:[self selectedType]])
	{
		[textField resignFirstResponder];
		[self animateRowChanges];
		return YES;
	}
	else {
		return NO;
	}
}

#pragma mark Cancel Button Events
- (void)cancelButtonPressed {
	if ([queryBuilderDelegate respondsToSelector:@selector(queryBuilder:didCancelEditingElementAtIndex:)]) {
		[queryBuilderDelegate queryBuilder:self didCancelEditingElementAtIndex:indexOfElementBeingEdited];
	}
	[textEditField resignFirstResponder];
}

#pragma mark Private methods

- (BOOL)presentsNewInputCellAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == numberOfElements);
}

- (void)initPickerView {
	self.pickerView = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
	CGSize pickerSize = [pickerView sizeThatFits:CGSizeZero];
	pickerView.frame = CGRectMake(0.0, 0.0, pickerSize.width, pickerSize.height);
	pickerView.showsSelectionIndicator = YES;
	pickerView.delegate = self;
}

- (void)initTextEditView {
	CGRect textEditViewFrame = CGRectMake(0.0, pickerView.frame.size.height, pickerView.frame.size.width, 48.0);
	self.textEditView = [[[UIView alloc] initWithFrame:textEditViewFrame] autorelease];
	textEditView.autoresizesSubviews = YES;
	textEditView.backgroundColor = [UIColor blackColor];
	CGRect textEditFieldFrame = CGRectMake(textEditFieldLeftMargin, (48.0 - textEditFieldHeight) / 2, pickerView.frame.size.width - textEditFieldLeftMargin - textEditFieldRightMargin - cancelButtonWidth - cancelButtonRightMargin, textEditFieldHeight);
	self.textEditField = [[[UITextField alloc] initWithFrame:textEditFieldFrame] autorelease];
	textEditField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
	textEditField.delegate = self;
	textEditField.borderStyle = UITextBorderStyleRoundedRect;
	textEditField.clearButtonMode = UITextFieldViewModeAlways;
	textEditField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textEditField.autocorrectionType = UITextAutocorrectionTypeNo;
	textEditField.keyboardType = UIKeyboardTypeASCIICapable;
	textEditField.returnKeyType = UIReturnKeyDone;
	textEditField.adjustsFontSizeToFitWidth = YES;
	textEditField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textEditField.enablesReturnKeyAutomatically = YES;
	[textEditView addSubview:textEditField];
	CGRect cancelButtonFrame = CGRectMake(textEditField.frame.origin.x + textEditField.frame.size.width + textEditFieldRightMargin, textEditField.frame.origin.y, cancelButtonWidth, textEditField.frame.size.height);
	self.cancelButton = [UIButton darkGrayButton];
	cancelButton.frame = cancelButtonFrame;
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[textEditView addSubview:cancelButton];
}

- (void)scrollPickerViewPastTypesThatCanNotStartWithText:(NSString *)text {
	if ([queryBuilderDelegate respondsToSelector:@selector(queryBuilder:type:canStartWithText:atIndex:)] && [pickerView numberOfRowsInComponent:0] > 1) {
		NSInteger startPickerIndex = [pickerView selectedRowInComponent:0];
		NSInteger newPickerIndex = startPickerIndex;
		BOOL wrappedAround = NO;
		while (![queryBuilderDelegate queryBuilder:self 
														  type:[candidateTypes objectAtIndex:newPickerIndex] 
										  canStartWithText:text 
													  atIndex:indexOfElementBeingEdited] &&
				 !(wrappedAround && newPickerIndex == startPickerIndex))
		{
			newPickerIndex++;
			if (newPickerIndex == [pickerView numberOfRowsInComponent:0]) {
				newPickerIndex = 0;
				wrappedAround = YES;
			}
		}
		if (newPickerIndex != startPickerIndex) {
			[pickerView selectRow:newPickerIndex inComponent:0 animated:YES];
		}
	}
}

- (NSObject <DTQueryBuilderElementType> *)selectedType {
	NSInteger selectedRow = [pickerView selectedRowInComponent:0];
	if (selectedRow >= 0 && selectedRow < [candidateTypes count]) {
		return [candidateTypes objectAtIndex:[pickerView selectedRowInComponent:0]];
	}
	else {
		return nil;
	}
}

- (void)updateRowMetadata {
	numberOfElements = [queryBuilderDelegate numberOfElementsForQueryBuilder:self];
	shouldShowNewInputCell = [self checkShouldShowNewInputCell];

}

- (BOOL)checkShouldShowNewInputCell {
	return (![queryBuilderDelegate respondsToSelector:@selector(newInputCellShouldBeShownByQueryBuilder:)] || 
			  [queryBuilderDelegate newInputCellShouldBeShownByQueryBuilder:self]);
}

- (void)animateRowChanges {
	if ([self isEditingNewInput]) {
		[self updateRowMetadata];
		[self.tableView beginUpdates];
		if (!shouldShowNewInputCell) {
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfElementBeingEdited inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		}
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfElementBeingEdited inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
	}
	else {
		BOOL wasShowingNewInputCell = shouldShowNewInputCell;
		[self updateRowMetadata];
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfElementBeingEdited inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexOfElementBeingEdited inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
		if (wasShowingNewInputCell && !shouldShowNewInputCell) {
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:numberOfElements inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		}
		else if (!wasShowingNewInputCell && shouldShowNewInputCell) {
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:numberOfElements inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		}
		[self.tableView endUpdates];
	}
}

- (BOOL) isEditingNewInput {
	return indexOfElementBeingEdited == numberOfElements;
}
		 
- (void) startEditingSelectedElement {
	if ([queryBuilderDelegate respondsToSelector:@selector(queryBuilder:willStartEditingElementAtIndex:)]) {
		[queryBuilderDelegate queryBuilder:self willStartEditingElementAtIndex:indexOfElementBeingEdited];
	}
	self.candidateTypes = [queryBuilderDelegate queryBuilder:self typesForElementAtIndex:indexOfElementBeingEdited];
	NSAssert ([candidateTypes count] >= 1, @"At least one candidate type must be defined to edit this element");
	if (indexOfElementBeingEdited < numberOfElements) {
		self.elementBeingEdited = [queryBuilderDelegate queryBuilder:self elementAtIndex:indexOfElementBeingEdited];
		textEditField.text = elementBeingEdited.text;
		[pickerView selectRow:[candidateTypes indexOfObject:elementBeingEdited.type] inComponent:0 animated:NO];
	}
	else {
		self.elementBeingEdited = nil;
		textEditField.text = @"";
		[pickerView selectRow:0 inComponent:0 animated:NO];
	}
	[[[UIApplication sharedApplication] keyWindow] addSubview:textEditView];
	[textEditField becomeFirstResponder];
}

@end
