//
//  Vector4SliderView.m
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import "Vector4SliderView.h"
#import "NSObject+Zest.h"
#import "CBucks.h"
#import <GLKit/GLKit.h>

@interface Vector4SliderView() {
@private
}
@end

@implementation Vector4SliderView

@synthesize value, minValue, maxValue;
@synthesize titleLabel, titleLabel0, titleLabel1, titleLabel2, titleLabel3;
@synthesize minLabel0, minLabel1, minLabel2, minLabel3;
@synthesize maxLabel0, maxLabel1, maxLabel2, maxLabel3;
@synthesize slider0, slider1, slider2, slider3;
@synthesize valueLabel;

+ (Vector4SliderView *) vector4SliderViewForRGBColor {
   Vector4SliderView *result = [Vector4SliderView objectFromNib: @"Vector4SliderView"];
   result.minValue = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
   result.maxValue = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
   result.value = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
   return result;
}

+ (Vector4SliderView *) vector4SliderViewForPosition {
   Vector4SliderView *result = [Vector4SliderView objectFromNib: @"Vector4SliderView"];
   result.minValue = GLKVector4Make(-10.0f, -10, -10, 0.0f);
   result.maxValue = GLKVector4Make(10.0f, 10.0f, 10.0f, 10.0f);
   result.value = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
   result.titleLabel0.text = @"X";
   result.titleLabel1.text = @"Y";
   result.titleLabel2.text = @"Z";
   result.titleLabel3.text = @"W";
   return result;
}


- (IBAction) sliderValueChanged: (UISlider *) slider {
   GLKVector4 newValue = value;
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
      case 3:
         newValue.a = (maxValue.a - minValue.a)*slider.value + minValue.a;
         break;
      default:
         break;
   }
   value = newValue;
   
   self.valueLabel.text = $S(@"%2.1f, %2.1f, %2.1f, %2.1f", value.r, value.g, value.b, value.a); 
   [self sendActionsForControlEvents: UIControlEventValueChanged];
}

- (void) setMinValue:(GLKVector4)newMinValue {
   minValue = newMinValue;
   self.minLabel0.text = $S(@"%2.1f", minValue.r);
   self.minLabel1.text = $S(@"%2.1f", minValue.g);
   self.minLabel2.text = $S(@"%2.1f", minValue.b);
   self.minLabel3.text = $S(@"%2.1f", minValue.a);
}

- (void) setMaxValue:(GLKVector4)newMax {
   maxValue = newMax;
   self.maxLabel0.text = $S(@"%2.1f", maxValue.r);
   self.maxLabel1.text = $S(@"%2.1f", maxValue.g);
   self.maxLabel2.text = $S(@"%2.1f", maxValue.b);
   self.maxLabel3.text = $S(@"%2.1f", maxValue.a);
}

- (void) setValue:(GLKVector4)newCurrentValue {
   value = newCurrentValue;
   self.slider0.value = (newCurrentValue.r - minValue.r)/(maxValue.r - minValue.r);
   self.slider1.value = (newCurrentValue.g - minValue.g)/(maxValue.g - minValue.g);
   self.slider2.value = (newCurrentValue.b - minValue.b)/(maxValue.b - minValue.b);
   self.slider3.value = (newCurrentValue.a - minValue.a)/(maxValue.a - minValue.a);
   self.valueLabel.text = $S(@"%2.1f, %2.1f, %2.1f, %2.1f", value.r, value.g, value.b, value.a); 
}



@end
