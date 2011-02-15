//
//  DTGaugeView.h
//  DTGaugeTest
//
//  Created by Curtis Duhn on 8/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTGaugeView : UIView {
	BOOL dtShowValueLabels;
	BOOL dtShowTickMarks;
	BOOL dtShowWarningBands;
	CGFloat currentValue;
	CGFloat lowValue;
	CGFloat highValue;
	CGFloat largeTickInterval;
	CGFloat minDegrees;
	CGFloat maxDegrees;
	CGFloat longTickWidth;
	CGFloat longTickHeight;
	CGFloat longTickStartRadius;
	CGFloat shortTickWidth;
	CGFloat shortTickStartRadius;
	CGFloat shortTickHeight;
	NSInteger shortTicksPerLongTick;
	NSMutableArray *tickLabels;
	UIView *needleView;
	UIView *pinView;
	CGFloat tickLabelRadius;
	CGFloat needleLength;
	CGFloat pinRadius;
	UIColor *gaugeMarkColor;
	UIColor *warningBandGreenColor;
	UIColor *warningBandYellowColor;
	UIColor *warningBandRedColor;
	CGFloat warningBandWidth;
	CGFloat warningBandHeight;
	CGFloat warningBandStartRadius;
	CGFloat yellowBottomValue;
	CGFloat yellowTopValue;
	CGFloat currentBaselineValue;
}

+ (id)viewWithFrame:(CGRect)theFrame;

@property (nonatomic) BOOL showValueLabels;
@property (nonatomic) BOOL showTickMarks;
@property (nonatomic) BOOL showWarningBands;
@property (nonatomic) CGFloat currentValue;
@property (nonatomic) CGFloat lowValue;
@property (nonatomic) CGFloat highValue;
@property (nonatomic) CGFloat largeTickInterval;
@property (nonatomic) CGFloat minDegrees;
@property (nonatomic) CGFloat maxDegrees;
@property (nonatomic) CGFloat longTickWidth;
@property (nonatomic) CGFloat longTickHeight;
@property (nonatomic) CGFloat longTickStartRadius;
@property (nonatomic) CGFloat shortTickWidth;
@property (nonatomic) CGFloat shortTickStartRadius;
@property (nonatomic) CGFloat shortTickHeight;
@property (nonatomic) NSInteger shortTicksPerLongTick;
@property (nonatomic, retain) NSMutableArray *tickLabels;
@property (nonatomic, retain) UIView *needleView;
@property (nonatomic, retain) UIView *pinView;
@property (nonatomic) CGFloat tickLabelRadius;
@property (nonatomic) CGFloat needleLength;
@property (nonatomic) CGFloat pinRadius;
@property (nonatomic, retain) UIColor *gaugeMarkColor;
@property (nonatomic, retain) UIColor *warningBandGreenColor;
@property (nonatomic, retain) UIColor *warningBandYellowColor;
@property (nonatomic, retain) UIColor *warningBandRedColor;
@property (nonatomic) CGFloat warningBandWidth;
@property (nonatomic) CGFloat warningBandHeight;
@property (nonatomic) CGFloat warningBandStartRadius;
@property (nonatomic) CGFloat yellowBottomValue;
@property (nonatomic) CGFloat yellowTopValue;
@property (nonatomic) CGFloat currentBaselineValue;

- (void)refreshNeedlePosition;

@end
