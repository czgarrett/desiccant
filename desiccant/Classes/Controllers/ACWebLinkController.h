//
//  ACWebLinkController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 2/12/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ACWebLinkController

- (BOOL)canHandleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
// Return YES if the controller chain should continue processing the link after this runs.  Return NO to abort link processing.
- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

