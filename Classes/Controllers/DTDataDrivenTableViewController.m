//
//  DTDataDrivenTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTDataDrivenTableViewController.h"
#import "DTSpinner.h"
#import "Zest.h"

@interface DTDataDrivenTableViewController()
- (DTCustomTableViewCell *)prototypeCell;
- (NSInteger)lastSection;
- (NSInteger)lastRowInSection:(NSInteger)section;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
@property (nonatomic, retain) UITableViewCell * prototype;
@property (nonatomic, retain) UITableViewCell *dtPrototypeMoreResultsCell;
@property (nonatomic, retain) UITableViewCell *dtNoResultsCell;
@end

@implementation DTDataDrivenTableViewController
@synthesize query, prototype, dtPrototypeMoreResultsCell, mediaWebView, moreResultsCellNibName, moreResultsCellIdentifier, dtNoResultsCell;

#pragma mark Memory management

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    self.query = nil;
    self.prototype = nil;
//    self.activityIndicator = nil;
	self.mediaWebView.delegate = nil;
    self.mediaWebView = nil;
	self.moreResultsCellNibName = nil;
	self.moreResultsCellIdentifier = nil;
	self.dtPrototypeMoreResultsCell = nil;
	self.dtNoResultsCell = nil;
    
    [super dealloc];
}

#pragma mark UIViewController methods

//- (id)init {
//	if (self = [super init]) {
//		statusBarHiddenBeforeMedia = [UIApplication sharedApplication].statusBarHidden;
//	}
//	return self;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//		statusBarHiddenBeforeMedia = [UIApplication sharedApplication].statusBarHidden;
//	}
//	return self;
//}
//
//- (id)initWithStyle:(UITableViewStyle)style {
//	if (self = [super initWithStyle:style]) {
//		statusBarHiddenBeforeMedia = [UIApplication sharedApplication].statusBarHidden;
//	}
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//	if (self = [super initWithCoder:aDecoder]) {
//		statusBarHiddenBeforeMedia = [UIApplication sharedApplication].statusBarHidden;
//	}
//	return self;
//}

- (void)viewDidLoad {
	self.moreResultsCellIdentifier = [NSString stringWithFormat:@"cell_type_%d", [DTCustomTableViewController nextIdentifierNumber]];
	[super viewDidLoad];
//	[[UIApplication sharedApplication] setStatusBarHidden:statusBarHiddenBeforeMedia animated:NO];
}

- (void)viewDidFirstAppear:(BOOL)animated {
	[super viewDidFirstAppear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:self.view.window];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[[UIApplication sharedApplication] setStatusBarHidden:statusBarHiddenBeforeMedia animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
//	[[UIApplication sharedApplication] setStatusBarHidden:statusBarHiddenBeforeMedia animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    if (query && !query.loaded) {
        [query refresh];
    }
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	if (query && query.updating) {
		[query cancel];
	}
	
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    if (query) {
        [query clear];
    }
}

#pragma mark Public methods

- (void)windowDidBecomeVisible:(NSNotification *)notification {
//	[[UIApplication sharedApplication] setStatusBarOrientation:[self interfaceOrientation]];
//	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	[[UIApplication sharedApplication] performSelector:@selector(setStatusBarOrientation:)  withInt:[self interfaceOrientation] afterDelay:0.25];
	[[UIApplication sharedApplication] bcompat_setStatusBarHidden:statusBarHiddenBeforeMedia withAnimation:UIStatusBarAnimationNone];
	UIView *rootView = [self.view.window.subviews objectAtIndex:0];
	if (rootView) {
		CGRect correctedFrame = [[UIScreen mainScreen] bounds];
//		if ([self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
//			correctedFrame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
//			correctedFrame.size.height = correctedFrame.size.height - correctedFrame.origin.y;
//		}
		rootView.frame = correctedFrame;
	}
}

- (void)windowDidBecomeHidden:(NSNotification *)notification {
//	[[UIApplication sharedApplication] setStatusBarHidden:statusBarHiddenBeforeMedia animated:NO];
}

- (BOOL)hasHeaders {
    return headerRows > 0;
}

- (NSIndexPath *)adjustIndexPathForHeaders:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:[self adjustSectionForHeaders:indexPath.section]];
}

- (NSInteger)adjustSectionForHeaders:(NSInteger)section {
    return ([self hasHeaders] && section > 0) ? section - 1 : section;
}

- (BOOL)indexPathIsHeader:(NSIndexPath *)indexPath {
    return [self hasHeaders] && indexPath.section == 0;
}

- (BOOL)indexPathIsMoreResultsCell:(NSIndexPath *)indexPath {
	return ([query hasMoreResults] && 
			indexPath.section == [self lastSection] && 
			indexPath.row == [self lastRowInSection:indexPath.section]);
}

//- (void)prepareActivityIndicator {
//    if (!activityIndicator) {
//        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
//        activityIndicator.hidesWhenStopped = YES;
//        activityIndicator.center = self.view.center;
//        [self.view addSubview:activityIndicator];
//    }
//}

- (void)showErrorForFailedQuery:(DTAsyncQuery *)theQuery {
	[self alertWithTitle:@"Query failed" message:theQuery.error];
}

- (void)hideErrorForFailedQuery {
}

- (UITableViewCell *)prototypeMoreResultsCell {
	if (moreResultsCellNibName && !dtPrototypeMoreResultsCell) {
		[[NSBundle mainBundle] loadNibNamed:moreResultsCellNibName owner:self options:nil];
		self.dtPrototypeMoreResultsCell = cell;
	}
	return dtPrototypeMoreResultsCell;
}

- (CGFloat)moreResultsCellRowHeight {
	if (self.moreResultsCellNibName) {
		return [self prototypeMoreResultsCell].bounds.size.height;
	}
	else {
		return 44.0;
	}
}

- (void)setNoResultsCellWithMessage:(NSString *)message {
	DTCustomTableViewCell *newCell = [[[DTCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	newCell.textLabel.text = message;
	newCell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 44.0f);
	newCell.textLabel.numberOfLines = 0;
	newCell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	newCell.textLabel.adjustsFontSizeToFitWidth = YES;
	newCell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
	newCell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	newCell.userInteractionEnabled = NO;
	[newCell layoutSubviews];
	newCell.textLabel.width = newCell.width - 20.0;
	newCell.textLabel.height = [newCell.textLabel heightToFitText];
	newCell.textLabel.y = 10.0f;
	newCell.height = newCell.textLabel.height + 20.0f;
	self.noResultsCell = newCell;
}

- (BOOL)hasNoResultsCell {
	return (self.noResultsCell != nil);
}

- (CGFloat)heightForNoResultsCell {
	return self.noResultsCell.height;
}

#pragma mark Public methods to be overridden

// Subclasses must implement this to return a header cell if headerRows > 0
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// Subclasses can override this to return a custom subclass of DTCustomTableViewCell with retain count 0 (autoreleased)
// for displaying the "More results" cell
- (DTCustomTableViewCell *)constructMoreResultsCell {
    DTCustomTableViewCell *newCell = [[[DTCustomTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:moreResultsCellIdentifier] autorelease];
	newCell.textLabel.text = @"more";
	newCell.textLabel.textColor = [UIColor grayColor];
	newCell.textLabel.textAlignment = UITextAlignmentRight;
	newCell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
	newCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return newCell;
}

// Subclasses can implement this to stream audio or video from a URL for the associated data
- (NSURL *)mediaURLFor:(NSMutableDictionary *)data {
    return nil;
}

// Subclasses can implement this to override the default header row height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

// Subclasses can implement this to override the default data cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForDataRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self indexPathIsMoreResultsCell:indexPath]) {
		return [self moreResultsCellRowHeight];
	}
	else if ([[self prototypeCell] hasDynamicHeight]) {
		[[self prototypeCell] setData:[self.query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
        return [self prototypeCell].bounds.size.height;
	}
    else if (self.cellNibName) {		
        return [self prototypeCell].bounds.size.height;
    }
    else {
        return [self.tableView rowHeight];
    }
}

// Subclasses can implement this to change the look & feel of any cell.  This is only called if cellNibName is not set. 
- (void)customizeCell {
}

// Subclasses can implement this to change the look & feel of the "More results..." cell.  This is only called if moreResultsCellNibName is not set. 
- (void)customizeMoreResultsCell {
}



#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self numberOfRowsInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *indexes;
    if (indexes = [query groupIndexes])  {
        if ([self hasHeaders]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:indexes];
            [tempArray insertObject:@"" atIndex:0];
            indexes = [NSArray arrayWithArray:tempArray];
        }
        return indexes;
    }
    else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self hasHeaders] && section == 0) return nil;
    else return [query titleForGroupWithIndex:[self adjustSectionForHeaders:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathIsHeader:indexPath]) {
        return [self headerRowForIndexPath:indexPath];
    }
	else if ([self indexPathIsMoreResultsCell:indexPath]) {
		cell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:moreResultsCellIdentifier];
		if (cell == nil) {
			if (moreResultsCellNibName) {
                [[NSBundle mainBundle] loadNibNamed:moreResultsCellNibName owner:self options:nil];
				NSAssert ([moreResultsCellNibName isEqual:cell.reuseIdentifier], @"For optimal performance, set Identifier for your cell in IB to match your nib name.");
				self.moreResultsCellIdentifier = cell.reuseIdentifier;
			}
			else {
				cell = [self constructMoreResultsCell];
				[self customizeMoreResultsCell];
			}
			[cell setData:[self.query cursorData]];
		}
		return cell;
	}
    else if ([query count] > 0) {
        cell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            if (cellNibName) {
                [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
                NSAssert ([cellNibName isEqual:cell.reuseIdentifier], @"For optimal performance, set Identifier for your cell in IB to match your nib name.");
                self.cellIdentifier = cell.reuseIdentifier;
            }
            else {
               cell = [self constructCell];
               self.cellIdentifier = cell.reuseIdentifier;
               [self customizeCell];
               unless (cell.delegate) cell.delegate = self;
            }
        }
        
        indexPath = [self adjustIndexPathForHeaders:indexPath];
        [cell setData:[self.query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
        return cell;
    }
	else {
		if ([self hasNoResultsCell]  && query.loaded) {
			return self.noResultsCell;
		}
		else {
			return nil;
		}
	}
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    unless ([self indexPathIsHeader:indexPath]) {
        indexPath = [self adjustIndexPathForHeaders:indexPath];
		unless ([self indexPathIsMoreResultsCell:indexPath]) {
			UIViewController *viewController = [self detailViewControllerFor:[query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
			if (viewController) {
				[[self navigationControllerToReceivePush] pushViewController:viewController animated:YES];
			}
			else {
				NSURL *mediaURL = [self mediaURLFor:[query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
				if (mediaURL) {
					self.mediaWebView = [[[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
					mediaWebView.delegate = self;
					[self.activityIndicator startAnimating];
					statusBarHiddenBeforeMedia = [UIApplication sharedApplication].statusBarHidden;
//					UIView *rootView = [[[self.view.window.subviews objectAtIndex:0] subviews] objectAtIndex:0];
					[[UIApplication sharedApplication] bcompat_setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
					[mediaWebView loadRequest:mediaURL.to_request];
				}
				[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
			}
		}
		else {
			[query fetchMoreResults];
		}
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathIsHeader:indexPath]) {
        return [self tableView:tableView heightForHeaderRowAtIndexPath:indexPath];
    }
    else if ([query count] > 0) {
		CGFloat height = [self tableView:tableView heightForDataRowAtIndexPath:indexPath];
        return height;
    }
	else {
		if ([self hasNoResultsCell] && query.loaded) {
			return [self heightForNoResultsCell];
		}
		else {
			return 0.0f;
		}
	}
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
}

#pragma mark DTAsyncQueryDelegate methods

- (void)queryWillStartLoading:(DTAsyncQuery *)feed {
//   [self prepareActivityIndicator];
   [self.activityIndicator startAnimating];
}


- (void)queryDidFinishLoading:(DTAsyncQuery *)theQuery {
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
    [self hideErrorForFailedQuery];
}

- (void)queryDidFailLoading:(DTAsyncQuery *)theQuery {
    [self.activityIndicator stopAnimating];
    [self showErrorForFailedQuery:theQuery];
}

- (void)queryWillStartLoadingMoreResults:(DTAsyncQuery *)theQuery {
	[self.activityIndicator startAnimating];
}

- (void)queryDidFinishLoadingMoreResults:(DTAsyncQuery *)theQuery {
	[self.tableView reloadData];
	[self.activityIndicator stopAnimating];
}

- (void)queryDidCancelLoadingMoreResults:(DTAsyncQuery *)theQuery {
	[self.activityIndicator stopAnimating];
}

- (void)queryDidFailLoadingMoreResults:(DTAsyncQuery *)theQuery {
	[self.activityIndicator stopAnimating];
	[self showErrorForFailedQuery:theQuery];
}

#pragma mark Dynamic properties

- (UITableViewCell *)noResultsCell {
	return self.dtNoResultsCell;
}

- (void)setNoResultsCell:(UITableViewCell *)theNoResultsCell {
	self.dtNoResultsCell = theNoResultsCell;
}


#pragma mark Private methods

- (DTCustomTableViewCell *)prototypeCell {
    if (cellNibName && !prototype) {
        [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
        self.prototype = cell;
    }
    return prototype;
}

// Subclasses can implement this to display a detail view for the associated data
- (UIViewController *)detailViewControllerFor:(NSDictionary *)data {
    return nil;
}

- (NSInteger)lastSection {
	return [self numberOfSections] - 1;
}

- (NSInteger)lastRowInSection:(NSInteger)section {
	return [self numberOfRowsInSection:section] - 1;
}

- (NSInteger)numberOfSections {
    if (headerRows == 0) return [query groupCount];
    else return [query groupCount] + 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if ([self hasHeaders] && section == 0) return headerRows;
    else if ([query count] > 0) {
		NSInteger numRows = [query rowCountForGroupWithIndex:[self adjustSectionForHeaders:section]];
		if ([query hasMoreResults] && [self adjustSectionForHeaders:section] == ([query groupCount] - 1)) {
			numRows += 1;
		}
		return numRows;
	}
	else {
		if ([self hasNoResultsCell] && query.loaded) {
			return 1;
		}
		else {
			return 0;
		}
	}
}

@end
