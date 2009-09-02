//
//  ACSearchListController.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/10/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "ACSearchListController.h"
#import "ACSearchListDataSource.h"
#import "ARObject.h"
#import "ACNavigationAppDelegate.h"
#import "ACModelObjectController.h"

@implementation ACSearchListController

@synthesize tableView, searchField, dataSource, editControllerClass, 
            newControllerClass, showControllerClass, activeRecordClass, queryColumn, searchFieldBarStyle, startWithKeyboardVisible, hideKeyboardWhenSearchButtonClicked,
            searchLimit, condition, orderColumn, resultsColumn, tableViewCellAccessoryType, stripDashesFromInput, stripSpacesFromInput;


- (id)init
{
	if (self = [super init]) {
		// Initialize your view controller.
		self.title = @"List";
      self.searchFieldBarStyle = UIBarStyleBlackOpaque;
		self.tableViewCellAccessoryType = UITableViewCellAccessoryNone;
		self.startWithKeyboardVisible = NO;
		self.hideKeyboardWhenSearchButtonClicked = NO;
		self.stripDashesFromInput = YES;
		self.stripSpacesFromInput = YES;
      self.condition = @"1";
      searchLimit = 100;
	}
	return self;
}

- (void)dealloc
{
	tableView.dataSource = nil;
	tableView.delegate = nil;

	self.view = nil;
	self.tableView = nil;
	self.searchField = nil;
	self.dataSource = nil;
   
   if (footerLabel) [footerLabel release];

	self.navigationItem.rightBarButtonItem = nil;
	[busyView release];
	[activityIndicator release];
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
   // Create the main table.
	UIView *rootView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 480.0)];
	rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	CGRect searchFrame = CGRectMake(0.0, 0.0, 320.0, kSearchFieldHeight);
	self.searchField = [[UISearchBar alloc] initWithFrame:searchFrame];
	searchField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
   searchField.placeholder = @"Search";
   searchField.backgroundColor = [UIColor whiteColor];	
	searchField.keyboardType = UIKeyboardTypeDefault;
	searchField.autocorrectionType =  UITextAutocorrectionTypeNo;
   searchField.barStyle = self.searchFieldBarStyle;
	searchField.delegate = self;
   searchField.showsCancelButton = YES;
   [rootView addSubview: searchField];

	CGRect tableFrame = CGRectMake(0.0, kSearchFieldHeight, rootView.frame.size.width, rootView.frame.size.height - kSearchFieldHeight);	
   tableView = [[UITableView alloc] initWithFrame: tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

   //tableView.tableHeaderView = searchField;
	[searchField release];

	[rootView addSubview: tableView];

	busyView = [[UIView alloc] initWithFrame: tableFrame];
	busyView.backgroundColor = [UIColor clearColor];
	busyView.opaque = NO;
	busyView.hidden = YES;
   busyView.userInteractionEnabled = YES;

	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center = CGPointMake(160.0, 100.0);
	[busyView addSubview: activityIndicator];
	[activityIndicator startAnimating];
	
	[rootView addSubview: busyView];

   self.view = rootView;
	[rootView release];
	
	// Add the Plus button on the right
   if (editControllerClass) {
      UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                    initWithTitle: @"Add" style: UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
      self.navigationItem.rightBarButtonItem = addButton;
      [addButton release];      
   }
   
   footerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 40.0)];
   footerLabel.lineBreakMode = UILineBreakModeWordWrap;
   footerLabel.textAlignment = UITextAlignmentCenter;
   footerLabel.font = [UIFont boldSystemFontOfSize: 14.0];
   footerLabel.numberOfLines = 3;
   self.tableView.tableFooterView = footerLabel;   
	
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	[self searchBarSearchButtonClicked: self.searchField];
}

- (void)viewWillDisappear: (BOOL)animated
{
	NSOperationQueue *operationQueue = [ACNavigationAppDelegate sharedOperationQueue];
   [operationQueue cancelAllOperations];
	tableView.dataSource = nil;
	self.dataSource = nil;
}

- (void)viewDidAppear: (BOOL)animated {
	if (self.startWithKeyboardVisible) {
		[searchField becomeFirstResponder];
	}
}

- (void)addAction:(id)sender
{
	// create an EventChooserController. This controller will display form for logging in
	UIViewController *newViewController = [[[newViewController class] alloc] init];
	
	// push the controller onto the navigation stack to display it
	[[self navigationController] pushViewController: newViewController animated:YES];
	[newViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
   return YES;
}

- (void)filterTextChanged:(NSString *)filterTextChanged {
   ACNavigationAppDelegate *appDelegate = (ACNavigationAppDelegate *) [[UIApplication sharedApplication] delegate];
   [[appDelegate operationQueue] cancelAllOperations];
	busyView.hidden = NO;
	NSString *text = [filterTextChanged copy];
	if (self.stripDashesFromInput) text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
	if (self.stripSpacesFromInput) text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	ACSearchListDataSource *theDataSource = [[ACSearchListDataSource alloc] initWithTableView: tableView 
                                                                           textFilter: text
                                                                           activeRecordClass: self.activeRecordClass
                                                                           delegate: self];
   theDataSource.queryColumn = self.queryColumn;
   theDataSource.searchLimit = self.searchLimit;
   theDataSource.condition = self.condition;
   theDataSource.orderColumn = self.orderColumn;
   theDataSource.resultsColumn = self.resultsColumn;
   [[appDelegate operationQueue] addOperation: theDataSource]; 
	[theDataSource release];   
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   editing = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
   editing = NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
   return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   [self filterTextChanged: searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   [self filterTextChanged: searchBar.text];
	if (self.hideKeyboardWhenSearchButtonClicked) [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   [searchBar resignFirstResponder];  
}
 
- (void)dataSourceIsReady:(id <UITableViewDataSource>)theDataSource
{
	tableView.dataSource = theDataSource;
	tableView.delegate = self;
	[tableView reloadData];
	self.dataSource = theDataSource;
	busyView.hidden = YES;
   if ([(ACSearchListDataSource *)theDataSource count] >= self.searchLimit) {
      footerLabel.text = @"Note: Too many search results to show all.  Enter a more specific search above.";
   } else {
      footerLabel.text = @"";
   }
   /*
   if (!self.dataSource.empty) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];    
      [tableView selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionTop];      
   }
   */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (busyView.hidden) {
      ARObject *chosenObject = [dataSource objectForSection: [indexPath section] row: [indexPath row]];
      if (editControllerClass) {
         UIViewController *editController = (UIViewController *) [[[editControllerClass class] alloc] initWithModelObject:chosenObject];
         // push the controller onto the navigation stack to display it
         [[self navigationController] pushViewController: editController animated:YES];
         [editController release];      
      }
      else if (showControllerClass) {
         UIViewController *showController = (UIViewController *) [(id<ACModelObjectController>)[[showControllerClass class] alloc] initWithModelObject:chosenObject];
         [[self navigationController] pushViewController: showController animated:YES];
         [self.tableView deselectRowAtIndexPath: indexPath animated: YES];
         [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
         [showController release];
      }
   }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return self.tableViewCellAccessoryType;
}

@end 
