//
//  DTTitleSubtitleCell.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTitleSubtitleCell.h"
#import "Zest.h"

@implementation DTTitleSubtitleCell
@synthesize title, subtitle;

- (void)dealloc {
    self.title = nil;
    self.subtitle = nil;
    
    [super dealloc];
}

// Subclasses can override this to set fields given an untyped data object
- (void)setData:(NSDictionary *)data {
    self.title.text = [data stringForKey:@"title"];
    self.subtitle.text = [data stringForKey:@"subtitle"];
}

@end
