//
//  ACDocumentViewController.m
//
//  Created by Christopher Garrett on 7/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ACDocumentViewController.h"

@implementation ACDocumentViewController

//@synthesize fileMenuItem, baseURL, searchHandler, searchBar;
//
//
//#pragma mark view management
//
//- (void)loadView {
//   UIView *containerView = [[UIView alloc] init]; //WithFrame: CGRectMake(0.0, 0.0, 320.0, 480.0)];
//   containerView.backgroundColor = [UIColor blackColor];
//   containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
//   if (searchable) {
//      webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 40.0, 320.0, 440.0)];
//      webView.scalesPageToFit = YES;
//      webView.delegate = self;
//      searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 40.0)];
//      searchBar.placeholder = @"Search Document";
//      searchBar.keyboardType = UIKeyboardTypeAlphabet;
//      [containerView addSubview: searchBar];      
//      self.searchHandler = [[[ACWebSearchHandler alloc] initWithSearchBar: searchBar contentsController: self webView: webView] autorelease];
//   } else {
//      webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 440.0)];
//      webView.scalesPageToFit = YES;
//   }
//   
//   [containerView addSubview: webView];
//   
//   self.view = containerView;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//   return YES;
//}
//
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
//
//   if (interfaceOrientation == UIInterfaceOrientationPortrait) {
//      if (searchable) {
//         webView.frame = CGRectMake(0.0, 40.0, 320.0, 440.0);
//      } else {
//         webView.frame = CGRectMake(0.0, 0.0, 320.0, 440.0);         
//      }
//   } else {
//      if (searchable) {
//         webView.frame = CGRectMake(0.0, 40.0, 480.0, 280.0);         
//      } else {
//         webView.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);                  
//      }
//   }
//}
//
//
//- (void) viewWillAppear: (BOOL) animated {
//   [super viewWillAppear: animated];
//   
//   if (self.navigationController) {
//      searchBar.barStyle = self.navigationController.navigationBar.barStyle;
//      searchBar.translucent = self.navigationController.navigationBar.translucent;
//      searchBar.tintColor = self.navigationController.navigationBar.tintColor;
//   }
//   
//   self.baseURL = [NSURL fileURLWithPath: self.fileMenuItem.path];
//   if (searchable) {
//		NSStringEncoding encoding;
//		NSError *error;
//      [self.searchHandler setSearchableContent: [NSString stringWithContentsOfFile: self.fileMenuItem.path usedEncoding:&encoding error:&error] baseURL: self.baseURL];
//   } else {
//      [webView loadRequest: [NSURLRequest requestWithURL: self.baseURL]];
//   }
//}
//
//#pragma mark UIWebViewDelegate methods
//
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
//   if (searchable && self.searchHandler.searchResultsContent) {
//      [webView stringByEvaluatingJavaScriptFromString: @"window.location.hash = 'jump';"];      
//   }
//}
//
//#pragma mark init/destroy
//
//- (id) initWithFileMenuItem: (FileMenuItem *) myFileMenuItem {
//   if (self = [super init]) {
//      self.fileMenuItem = myFileMenuItem;
//      self.title = self.fileMenuItem.title;
//      searchable = [self.fileMenuItem.path hasSuffix: @".html"];
//      self.hidesBottomBarWhenPushed = YES;
//   }
//   return self;
//}
//
//
//- (void)dealloc {
//   if (searchBar) [searchBar release];
//   if (webView) [webView release];
//   self.fileMenuItem = nil;
//   self.baseURL = nil;
//    [super dealloc];
//}
//
//
@end
