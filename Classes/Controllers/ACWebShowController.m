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

@synthesize webView, linkControllerChain;

- (ACWebShowController *)init {
   if (self = [super init]) {
      self.linkControllerChain = [NSMutableArray array];
   }
   return self;
}

- (void)dealloc {
   [webView release];
   [linkControllerChain release];
   [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
   [super viewDidLoad];
   self.webView = [[[UIWebView alloc] init] autorelease];
   self.view = self.webView;
}

- (void) viewWillAppear: (BOOL) animated {
   [self reloadWebView];
}

- (void) reloadWebView {
   [webView loadHTMLString:[self toHTML] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (NSString *) toHTML {
   return [NSString stringWithFormat:@"<html><head><title>%@ id:%d</title></head><body><h1>%@ id:%d</h1><p>You probably want to override toHTML on your WebViewController subclass.</p></body></html>", 
           [[modelObject class] tableName], [modelObject primaryKey], [[modelObject class] tableName], [modelObject primaryKey]];
}

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

- (void)addLinkController:(id <ACWebLinkController>)controller {
   [self.linkControllerChain addObject:controller];
}

@end
