//
//  ACAboutViewController.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 4/29/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "ACAboutViewController.h"


@implementation ACAboutViewController

@synthesize webView;

- (void) viewWillAppear: (BOOL) animated {
   [super viewWillAppear: animated];
   [self reloadWebView];
}

- (void) reloadWebView {
   NSStringEncoding encoding;
   NSError *error;
   NSString *fileContents = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"About" ofType: @"html"] usedEncoding:&encoding error:&error];
   [webView loadHTMLString: fileContents baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];   
}

- (void)dealloc {
    [super dealloc];
}


@end
