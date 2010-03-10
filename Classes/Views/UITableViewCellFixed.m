//
//  UITableViewCellFixed.m
//  PortablePTO
//
//  Created by Christopher Garrett on 7/16/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "UITableViewCellFixed.h"


@implementation UITableViewCellFixed
- (void) layoutSubviews {
   [super layoutSubviews];
#ifdef __IPHONE_3_0   
   self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 
                                      4.0, 
                                      self.textLabel.frame.size.width, 
                                      self.textLabel.frame.size.height);
   self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, 
                                           8.0 + self.textLabel.frame.size.height, 
                                           self.detailTextLabel.frame.size.width, 
                                           self.detailTextLabel.frame.size.height);
#endif
}

@end
