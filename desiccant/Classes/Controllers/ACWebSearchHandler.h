//
//  ACWebSearchHandler.h
//
//  Created by Christopher Garrett on 8/15/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ACWebSearchHandler : NSObject <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {

   UISearchBar *searchBar;
   UISearchDisplayController *searchDisplayController;
   NSString *searchableContent;
   NSString *searchResultsContent;
   NSString *currentSearchRegex;
   NSArray *searchResults;
   UIWebView *webView;
   NSURL *baseURL;
}

@property (nonatomic, retain) NSString *searchableContent;
@property (nonatomic, retain) NSString *searchResultsContent;
@property (nonatomic, retain) NSString *currentSearchRegex;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

- (id) initWithSearchBar: (UISearchBar *)mySearchBar 
      contentsController: (UIViewController *)contentsController
                 webView: (UIWebView *)webView;
- (void) setSearchableContent: (NSString *)content baseURL: (NSURL *) baseURL;

@end
