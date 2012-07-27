//
//  Vector4SliderView.h
//  word-game-3
//
//  Created by Garrett Christopher on 10/26/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface Vector4SliderView : UIControl

@property (nonatomic, assign) GLKVector4 value;
@property (nonatomic, assign) GLKVector4 minValue;
@property (nonatomic, assign) GLKVector4 maxValue;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel0;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel1;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel2;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel3;

@property (nonatomic, retain) IBOutlet UILabel *minLabel0;
@property (nonatomic, retain) IBOutlet UILabel *minLabel1;
@property (nonatomic, retain) IBOutlet UILabel *minLabel2;
@property (nonatomic, retain) IBOutlet UILabel *minLabel3;

@property (nonatomic, retain) IBOutlet UILabel *maxLabel0;
@property (nonatomic, retain) IBOutlet UILabel *maxLabel1;
@property (nonatomic, retain) IBOutlet UILabel *maxLabel2;
@property (nonatomic, retain) IBOutlet UILabel *maxLabel3;

@property (nonatomic, retain) IBOutlet UISlider *slider0;
@property (nonatomic, retain) IBOutlet UISlider *slider1;
@property (nonatomic, retain) IBOutlet UISlider *slider2;
@property (nonatomic, retain) IBOutlet UISlider *slider3;


@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

- (IBAction) sliderValueChanged: (UISlider *) slider;

+ (Vector4SliderView *) vector4SliderViewForRGBColor;
+ (Vector4SliderView *) vector4SliderViewForPosition;



@end