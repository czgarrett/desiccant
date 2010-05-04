//
//  ACWebSearchHandler.m
//
//  Created by Christopher Garrett on 8/15/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ACWebSearchHandler.h"
#import "RegexKitLite.h"


@implementation ACWebSearchHandler

@synthesize searchableContent, searchResults, searchResultsContent, currentSearchRegex, 
            searchDisplayController, webView, searchBar, baseURL;

- (void) setSearchableContent: (NSString *)content baseURL: (NSURL *) myBaseURL {
   self.searchableContent = content;
   self.baseURL = myBaseURL;
   [self.webView loadHTMLString: self.searchableContent baseURL: self.baseURL];
}
#pragma mark search datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      cell.textLabel.numberOfLines = 2;
      cell.textLabel.font = [UIFont fontWithName: @"Helvetica" size: 12.0];
      cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
	}
	cell.textLabel.text = [[self.searchResults objectAtIndex: indexPath.row] stringByReplacingOccurrencesOfRegex: @"(?:\\r\\n|[\\n\\f\\r\\p{Zl}\\p{Zp}])" withString: @" "];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
   NSRange itemRange = NSMakeRange(0, 0);
   NSRange searchRange;
   for (int i=0; i<= indexPath.row; i++) {
      NSInteger searchStart = itemRange.location + itemRange.length;
      searchRange = NSMakeRange(searchStart, self.searchableContent.length - searchStart);
      itemRange = [self.searchableContent rangeOfString: [self.searchResults objectAtIndex: i] 
                   options: NSLiteralSearch 
                   range: searchRange];
   }
   NSString *foundString = [searchResults objectAtIndex: indexPath.row];
   NSString *highlightedSearchTerm = [NSString stringWithFormat: @"<span style=\"background-color: yellow; font-weight: bold;\">%@</span>", [searchBar.text uppercaseString]];
   NSString *highlightedResult = [foundString stringByReplacingOccurrencesOfString: searchBar.text 
                                                                        withString: highlightedSearchTerm 
                                                                           options: NSCaseInsensitiveSearch 
                                                                             range: NSMakeRange(0, foundString.length)];
   NSString *anchor = [NSString stringWithFormat: @"<a name=\"jump\"></a>%@", highlightedResult];
   self.searchResultsContent = [self.searchableContent stringByReplacingOccurrencesOfString: foundString 
                                withString: anchor options: NSLiteralSearch range: itemRange];
   [self.webView loadHTMLString: self.searchResultsContent baseURL: self.baseURL];
   //NSLog(@"%@", self.searchResultsContent);
   [self.searchDisplayController setActive: NO animated: YES];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   searchDisplayController.searchResultsTableView.delegate = self;
   if ([searchString length] > 2) {
      self.currentSearchRegex = [NSString stringWithFormat: @"(?is)[^{title}]>[^<]*?([^<]{0,40}%@[^<.]{0,50})[^<]*?<", searchString];
      self.searchResults = [searchableContent componentsMatchedByRegex: self.currentSearchRegex capture: 1];
      if ([searchResults count] > 100) {
         self.searchResults = [searchResults subarrayWithRange: NSMakeRange(0, 100)];
      }      
   } else {
      self.searchResults = [NSArray array];
   }
   
   return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
   self.searchResultsContent = nil;
}


#pragma mark init/destroy

- (id) initWithSearchBar: (UISearchBar *)mySearchBar contentsController: (UIViewController *)contentsController webView: (UIWebView *)myWebView {
   if (self = [super init]) {
      self.searchBar = mySearchBar;
      self.webView = myWebView;
      searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar: self.searchBar contentsController: contentsController];
      searchDisplayController.delegate = self;
      searchDisplayController.searchResultsDataSource = self;
      searchDisplayController.searchResultsTableView.delegate = self;
      
      self.searchResults = [NSArray array];
   }
   return self;
}

- (void) dealloc {
   self.searchableContent = nil;
   self.searchResults = nil;
   self.searchResultsContent = nil;
   self.currentSearchRegex = nil;   
   self.searchDisplayController = nil;
   self.webView = nil;
   self.baseURL = nil;
   [super dealloc];
}

@end
