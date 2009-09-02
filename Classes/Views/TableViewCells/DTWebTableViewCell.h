//
//  DTWebTableViewCell.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCustomTableViewCell.h"

@interface DTWebTableViewCell : DTCustomTableViewCell {
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

// Subclasses should override this to render the web view given the data member object
- (void)reloadWebView;

@end
