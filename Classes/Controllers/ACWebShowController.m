//
//  ACWebShowController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 10/3/08.
//  Copyright 2008 ZWorkbench. All rights reserved.
//

#import "ACWebShowController.h"
#import "ACWebLinkController.h"


@implementation ACWebShowController

@synthesize webView, linkControllerChain, searchHandler, searchBar;

#pragma mark view management

- (void)loadView {
   UIView *containerView = [[UIView alloc] init]; //WithFrame: CGRectMake(0.0, 0.0, 320.0, 480.0)];
   containerView.backgroundColor = [UIColor blackColor];
   containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   if (searchable) {
      webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 40.0, 320.0, 440.0)];
      //webView.scalesPageToFit = YES;
      webView.delegate = self;
      searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 40.0)];
      searchBar.placeholder = @"Search Document";
      searchBar.keyboardType = UIKeyboardTypeAlphabet;
      [containerView addSubview: searchBar];      
      self.searchHandler = [[[ACWebSearchHandler alloc] initWithSearchBar: searchBar contentsController: self webView: webView] autorelease];
   } else {
      webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 440.0)];
      //webView.scalesPageToFit = YES;
   }
   
   [containerView addSubview: webView];
   
   self.view = containerView;
}

- (void) viewWillAppear: (BOOL) animated {
   [self reloadWebView];
   if (searchable && self.navigationController) {
      searchBar.barStyle = self.navigationController.navigationBar.barStyle;
      searchBar.translucent = self.navigationController.navigationBar.translucent;
      searchBar.tintColor = self.navigationController.navigationBar.tintColor;
   }
}

- (void) reloadWebView {
   NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
   if (searchable) {
      [self.searchHandler setSearchableContent: [self toHTML] baseURL: baseURL];
   } else {
      [webView loadHTMLString:[self toHTML] baseURL: baseURL];   
   }
}

#pragma mark  view rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
   
   if (interfaceOrientation == UIInterfaceOrientationPortrait) {
      if (searchable) {
         webView.frame = CGRectMake(0.0, 40.0, 320.0, 440.0);
      } else {
         webView.frame = CGRectMake(0.0, 0.0, 320.0, 440.0);         
      }
   } else {
      if (searchable) {
         webView.frame = CGRectMake(0.0, 40.0, 480.0, 280.0);         
      } else {
         webView.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);                  
      }
   }
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)specifiedWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   BOOL continueProcessing = YES;
   for (int i=0; i < [self.linkControllerChain count]; i++) {
      if ([(id <ACWebLinkController>)[self.linkControllerChain objectAtIndex:i] canHandleRequest:request navigationType:navigationType]) {
         continueProcessing = continueProcessing && [(id <ACWebLinkController>)[self.linkControllerChain objectAtIndex:i] handleRequest:request navigationType:navigationType];
      }
      if (!continueProcessing) break;
   }
   return continueProcessing;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
   if (searchable && self.searchHandler.searchResultsContent) {
      [webView stringByEvaluatingJavaScriptFromString: @"window.location.hash = 'jump';"];      
   }
}

#pragma mark misc

- (void)addLinkController:(id <ACWebLinkController>)controller {
   [self.linkControllerChain addObject:controller];
}

- (NSString *) toHTML {
   return [NSString stringWithFormat:@"<html><head><title>%@ id:%d</title></head><body><h1>%@ id:%d</h1><p>You probably want to override toHTML on your WebViewController subclass.</p></body></html>", 
           [[modelObject class] tableName], [modelObject primaryKey], [[modelObject class] tableName], [modelObject primaryKey]];
}

#pragma mark init/destroy

- (ACWebShowController *)init {
   return [self initSearchable: NO];
}

- (id) initSearchable: (BOOL) amSearchable {
   if (self = [super init]) {
      self.linkControllerChain = [NSMutableArray array];
      self.hidesBottomBarWhenPushed = YES;
      searchable = amSearchable;
   }
   return self;
}

- (void)dealloc {
   self.webView = nil;
   self.linkControllerChain = nil;
   self.searchBar = nil;
   self.searchHandler = nil;
   [super dealloc];
}


@end
