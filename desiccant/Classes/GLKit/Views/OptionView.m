//
//  OptionView.m
//  qatqi
//
//  Created by Garrett Christopher on 10/28/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "OptionView.h"
#import "NSObject+Zest.h"

@implementation OptionView

@synthesize titleLabel, segmentedControl;

+ (OptionView *) optionViewWithTitle: (NSString *) title options: (NSArray *) options {
   OptionView *result = [OptionView objectFromNib: @"OptionView"];
   [result.segmentedControl removeAllSegments];
   result.titleLabel.text = title;
   for (int i=0; i<[options count]; i++) {
      [result.segmentedControl insertSegmentWithTitle: [options objectAtIndex: i] atIndex: i animated: NO];
   }
   return result;
}

- (void) setSelectedIndex:(NSInteger)selectedIndex {
   self.segmentedControl.selectedSegmentIndex = selectedIndex;
}

- (NSInteger) selectedIndex {
   return self.segmentedControl.selectedSegmentIndex;
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *) control {
   [self sendActionsForControlEvents: UIControlEventValueChanged];
}

@end
