//
//  DTDataDrivenTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTDataDrivenTableViewController.h"
#import "DTSpinner.h"

@interface DTDataDrivenTableViewController()
- (UITableViewCell *)prototypeCell;
@property (nonatomic, retain) UITableViewCell * prototype;
@end

@implementation DTDataDrivenTableViewController
@synthesize query, prototype, activityIndicator, mediaWebView;

- (void)dealloc {
    self.query = nil;
    self.prototype = nil;
    self.activityIndicator = nil;
    self.mediaWebView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated {
    if (query && !query.loaded) {
        [query refresh];
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    if (query) {
        [query clear];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (headerRows == 0) return [query groupCount];
    else return [query groupCount] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasHeaders] && section == 0) return headerRows;
    else return [query rowCountForGroupWithIndex:[self adjustSectionForHeaders:section]];
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

// Subclasses must implement this to return a header cell if headerRows > 0
- (UITableViewCell *)headerRowForIndexPath:(NSIndexPath *)indexPath {
    return nil;
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathIsHeader:indexPath]) {
        return [self headerRowForIndexPath:indexPath];
    }
    else {
        tempCell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (tempCell == nil) {
            if (cellNibName) {
                [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
                self.cellIdentifier = tempCell.reuseIdentifier;
            }
            else {
                tempCell = [self constructCell];
                [self customizeCell];
            }
        }
        
        indexPath = [self adjustIndexPathForHeaders:indexPath];
        [tempCell setData:[self.query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];

        return tempCell;
    }    
}


- (void)prepareActivityIndicator {
    if (!activityIndicator) {
        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.center = self.view.center;
        [self.view addSubview:activityIndicator];
    }
}

- (void)queryWillStartLoading:(DTAsyncQuery *)feed {
    [self prepareActivityIndicator];
    [activityIndicator startAnimating];
}

- (void)queryDidFinishLoading:(DTAsyncQuery *)feed {
    [activityIndicator stopAnimating];
    NSLog([self.tableView description]);
    [self.tableView reloadData];
    [self hideErrorForFailedQuery];
}

- (void)queryDidFailLoading:(DTAsyncQuery *)feed {
    [activityIndicator stopAnimating];
    [self showErrorForFailedQuery:feed];
}

- (void)showErrorForFailedQuery:(DTAsyncQuery *)feed {
}

- (void)hideErrorForFailedQuery {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self indexPathIsHeader:indexPath]) {
        indexPath = [self adjustIndexPathForHeaders:indexPath];
        UIViewController *viewController = [self detailViewControllerFor:[query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
        if (viewController) {
            [[self navigationControllerToReceivePush] pushViewController:viewController animated:YES];
        }
        else {
            NSURL *mediaURL = [self mediaURLFor:[query itemAtIndex:indexPath.row inGroupWithIndex:indexPath.section]];
            if (mediaURL) {
                self.mediaWebView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
                mediaWebView.delegate = self;
                [self prepareActivityIndicator];
                [activityIndicator startAnimating];
                [mediaWebView loadRequest:mediaURL.to_request];
            }
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
//    [self displayMediaLoadError:error];
}

//- (void)displayMediaLoadError:(NSError *)error {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading media" 
//                                                    message:[NSString stringWithFormat:@"Sorry, but an error has occurred attempting to play this file.\n%@", [error localizedDescription]]
//                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];    
//    [alert release];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathIsHeader:indexPath]) {
        return [self tableView:tableView heightForHeaderRowAtIndexPath:indexPath];
    }
    else {
        return [self tableView:tableView heightForDataRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)prototypeCell {
    if (cellNibName && !prototype) {
        [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
        self.prototype = tempCell;
    }
    return prototype;
}

// Subclasses can implement this to display a detail view for the associated data
- (UIViewController *)detailViewControllerFor:(NSMutableDictionary *)data {
    return nil;
}

// Subclasses can implement this to stream audio or video from a URL for the associated data
- (NSURL *)mediaURLFor:(NSMutableDictionary *)data {
    return nil;
}


@end
