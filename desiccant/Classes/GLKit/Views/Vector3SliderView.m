//
//  Vector3SliderView.m
//  qatqi
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "Vector3SliderView.h"
#import "NSObject+Zest.h"
#import "CBucks.h"
#import <GLKit/GLKit.h>

@interface Vector3SliderView() {
@private
}
@end

@implementation Vector3SliderView

@synthesize value, minValue, maxValue;
@synthesize titleLabel, titleLabel0, titleLabel1, titleLabel2;
@synthesize minLabel0, minLabel1, minLabel2;
@synthesize maxLabel0, maxLabel1, maxLabel2;
@synthesize slider0, slider1, slider2;
@synthesize valueLabel;

+ (Vector3SliderView *) Vector3SliderViewForDirection {
   Vector3SliderView *result = [Vector3SliderView objectFromNib: @"Vector3SliderView"];
   result.minValue = GLKVector3Make(0.0f, 0.0f, 0.0f);
   result.maxValue = GLKVector3Make(1.0f, 1.0f, 1.0f);
   result.value = GLKVector3Make(1.0f, 1.0f, 1.0f);
   result.titleLabel0.text = @"X";
   result.titleLabel1.text = @"Y";
   result.titleLabel2.text = @"Z";
   return result;
}

- (IBAction) sliderValueChanged: (UISlider *) slider {
   GLKVector3 newValue = value;
   switch (slider.tag) {
      case 0:
         newValue.r = (maxValue.r - minValue.r)*slider.value + minValue.r;
         break;
      case 1:
         newValue.g = (maxValue.g - minValue.g)*slider.value + minValue.g;
         break;
      case 2:
         newValue.b = (maxValue.b - minValue.b)*slider.value + minValue.b;
         break;
      default:
         break;
   }
   value = newValue;
   
   self.valueLabel.text = $S(@"%2.1f, %2.1f, %2.1f", value.r, value.g, value.b); 
   [self sendActionsForControlEvents: UIControlEventValueChanged];
}

- (void) setMinValue:(GLKVector3)newMinValue {
   minValue = newMinValue;
   self.minLabel0.text = $S(@"%2.1f", minValue.r);
   self.minLabel1.text = $S(@"%2.1f", minValue.g);
   self.minLabel2.text = $S(@"%2.1f", minValue.b);
}

- (void) setMaxValue:(GLKVector3)newMax {
   maxValue = newMax;
   self.maxLabel0.text = $S(@"%2.1f", maxValue.r);
   self.maxLabel1.text = $S(@"%2.1f", maxValue.g);
   self.maxLabel2.text = $S(@"%2.1f", maxValue.b);
}

- (void) setValue:(GLKVector3)newCurrentValue {
   value = newCurrentValue;
   self.slider0.value = (newCurrentValue.r - minValue.r)/(maxValue.r - minValue.r);
   self.slider1.value = (newCurrentValue.g - minValue.g)/(maxValue.g - minValue.g);
   self.slider2.value = (newCurrentValue.b - minValue.b)/(maxValue.b - minValue.b);
   self.valueLabel.text = $S(@"%2.1f, %2.1f, %2.1f", value.r, value.g, value.b); 
}



@end
