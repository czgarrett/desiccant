//
//  FloatSliderView.m
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "FloatSliderView.h"
#import "CBucks.h"
#import "NSObject+Zest.h"

@interface FloatSliderView() {
@private

}

- (void) updateCurrentValueLabel;


@end

@implementation FloatSliderView

@synthesize minValueLabel, maxValueLabel, titleLabel, currentValueLabel;
@synthesize title, minValue, maxValue, value, slider;

+ (FloatSliderView *) floatSliderViewWithTitle: (NSString *) title min: (float) min max: (float) max current: (float) current {
   FloatSliderView *result = [FloatSliderView objectFromNib: @"FloatSliderView"];
   result.title = title;
   result.minValue = min;
   result.maxValue = max;
   result.value = current;
   return result;
}


- (void) awakeFromNib {
   [super awakeFromNib];
   self.minValue = 0.0f;
   self.maxValue = 1.0f;
}

- (void) setTitle:(NSString *)newTitle {
   self.titleLabel.text = newTitle;
}

- (NSString *) title {
   return self.titleLabel.text;
}

- (void) updateCurrentValueLabel {
   if (value < 1.0f) {
      self.currentValueLabel.text = $S(@"%2.2f", value); 
   } else {
      self.currentValueLabel.text = $S(@"%2.1f", value); 
   }
}

- (IBAction) sliderValueChanged: (UISlider *) theSlider {
   self.value = (maxValue - minValue)*slider.value + minValue;
   
   [self updateCurrentValueLabel];
   [self sendActionsForControlEvents: UIControlEventValueChanged];
}

- (void) setMinValue:(float)newMinValue {
   minValue = newMinValue;
   self.minValueLabel.text = $S(@"%2.1f", minValue);
}

- (void) setMaxValue:(float)newMaxValue {
   maxValue = newMaxValue;
   self.maxValueLabel.text = $S(@"%2.1f", maxValue);
}

- (void) setValue:(float)newCurrentValue {
   value = newCurrentValue;
   [self updateCurrentValueLabel];
   self.slider.value = (newCurrentValue - minValue)/(maxValue - minValue);
}

@end
