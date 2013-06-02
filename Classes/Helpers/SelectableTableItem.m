//
//  SelectableTableItem.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 8/30/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "SelectableTableItem.h"


@implementation SelectableTableItem

@synthesize description;
@synthesize selector;
@synthesize iconName;

- (id) initWithDescription: (NSString *)myDescription selector:(SEL)mySelector iconName: (NSString *)myIconName {
   if (self = [super init]) {
      self.description = myDescription;
      self.selector = mySelector;
      self.iconName = myIconName;
   }
   return self;
}

@end
