//
//  DTWebTableViewCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTWebTableViewCell.h"


@implementation DTWebTableViewCell
@synthesize webView;

- (void)dealloc {
    self.webView = nil;
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    [self reloadWebView];
}

- (void)reloadWebView {
}

@end
