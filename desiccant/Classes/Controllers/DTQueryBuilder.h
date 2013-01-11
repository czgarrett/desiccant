//
//  DTQueryBuilder.h
//  Desiccant
//
//  Created by Curtis Duhn on 11/2/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@protocol DTQueryBuilderDelegate;
@protocol DTQueryBuilderElement;

@interface DTQueryBuilder : DTTableViewController <UITextFieldDelegate, UIPickerViewDelegate> {
	NSObject <DTQueryBuilderDelegate> *queryBuilderDelegate;
	NSInteger numberOfElements;
	UIPickerView *pickerView;
	UIView *textEditView;
	UITextField *textEditField;
	NSObject <DTQueryBuilderElement> *elementBeingEdited;
	NSInteger indexOfElementBeingEdited;
	CGFloat textEditFieldLeftMargin;
	CGFloat textEditFieldRightMargin;
	CGFloat textEditFieldHeight;
	CGFloat cancelButtonWidth;
	CGFloat cancelButtonRightMargin;
	CGFloat pickerViewRowHeight;
	CGFloat pickerViewRowWidth;
	CGFloat pickerViewLeftMargin;
	CGFloat pickerViewRightMargin;
	UIButton *cancelButton;
	NSArray *candidateTypes;
	BOOL shouldShowNewInputCell;
}

@property (nonatomic, retain) NSObject <DTQueryBuilderDelegate> *queryBuilderDelegate;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIView *textEditView;
@property (nonatomic, retain) UITextField *textEditField;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) NSArray *candidateTypes;
@property (nonatomic, retain) NSObject <DTQueryBuilderElement> *elementBeingEdited;
@property (nonatomic) NSInteger indexOfElementBeingEdited;
@property (nonatomic) CGFloat textEditFieldLeftMargin;
@property (nonatomic) CGFloat textEditFieldRightMargin;
@property (nonatomic) CGFloat textEditFieldHeight;
@property (nonatomic) CGFloat cancelButtonWidth;
@property (nonatomic) CGFloat cancelButtonRightMargin;
@property (nonatomic) CGFloat pickerViewRowHeight;
@property (nonatomic) CGFloat pickerViewRowWidth;
@property (nonatomic) CGFloat pickerViewLeftMargin;
@property (nonatomic) CGFloat pickerViewRightMargin;
@property (nonatomic) BOOL shouldShowNewInputCell;

- (id)initWithQueryBuilderDelegate:(NSObject <DTQueryBuilderDelegate> *)theDelegate;
+ (DTQueryBuilder *)builderWithDelegate:(NSObject <DTQueryBuilderDelegate> *)theDelegate;

@end
