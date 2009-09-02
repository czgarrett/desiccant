//
//  ACSearchListController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/10/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TableViewDataSourceDelegate.h"

@class ACSearchListDataSource;

@interface ACSearchListController : UIViewController <UISearchBarDelegate, TableViewDataSourceDelegate, UITableViewDelegate> {
	UITableView *tableView;
	UISearchBar *searchField;
   BOOL editing;
	ACSearchListDataSource *dataSource;
	
	UIActivityIndicatorView *activityIndicator;
	UIView *busyView;
   
   UILabel *footerLabel;
   
   // Customizable properties
   UIBarStyle searchFieldBarStyle;
	UITableViewCellAccessoryType tableViewCellAccessoryType;
	
   // Querying properties
   Class activeRecordClass;
   NSString *queryColumn;
   NSString *condition;
   NSString *orderColumn;
   NSString *resultsColumn;
   NSInteger searchLimit;
	BOOL startWithKeyboardVisible;
	BOOL hideKeyboardWhenSearchButtonClicked;
	BOOL stripDashesFromInput;
	BOOL stripSpacesFromInput;
	
	Class editControllerClass;
	Class newControllerClass;
   Class showControllerClass;
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UISearchBar *searchField;
@property (nonatomic,retain) ACSearchListDataSource *dataSource;

@property (nonatomic, assign) UIBarStyle searchFieldBarStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType tableViewCellAccessoryType;

// Querying properties
@property (nonatomic) Class activeRecordClass;
@property (nonatomic, retain) NSString *queryColumn;
@property (nonatomic, retain) NSString *condition;
@property (nonatomic, retain) NSString *orderColumn;
@property (nonatomic, retain) NSString *resultsColumn;
@property (nonatomic, assign) NSInteger searchLimit;
@property (nonatomic) BOOL startWithKeyboardVisible;
@property (nonatomic) BOOL hideKeyboardWhenSearchButtonClicked;
@property (nonatomic) BOOL stripDashesFromInput;
@property (nonatomic) BOOL stripSpacesFromInput;

@property (nonatomic) Class editControllerClass;
@property (nonatomic) Class newControllerClass;
@property (nonatomic) Class showControllerClass;

- (void) filterTextChanged: (NSString *)filterText;

@end
