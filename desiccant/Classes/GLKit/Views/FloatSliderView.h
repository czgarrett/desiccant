//
//  FloatSliderView.h
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatSliderView : UIControl

@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign) float value;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, retain) IBOutlet UILabel *minValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *maxValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) IBOutlet UISlider *slider;

+ (FloatSliderView *) floatSliderViewWithTitle: (NSString *) title min: (float) min max: (float) max current: (float) current;

-(IBAction) sliderValueChanged: (UISlider *) slider;

@end
