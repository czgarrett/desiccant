//
//  OptionView.h
//  word-game-3
//
//  Created by Garrett Christopher on 10/28/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionView : UIControl

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, assign) NSInteger selectedIndex;

+ (OptionView *) optionViewWithTitle: (NSString *) title options: (NSArray *) options;

- (IBAction)segmentedControlChanged:(UISegmentedControl *) control;

@end
