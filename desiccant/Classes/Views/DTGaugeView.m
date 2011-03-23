//
//  DTGaugeView.m
//  DTGaugeTest
//
//  Created by Curtis Duhn on 8/20/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGaugeView.h"
#import "Zest.h"
#import "CBucks.h"

#define DEFAULT_SHOW_WARNING_BANDS NO
#define DEFAULT_SHOW_VALUE_LABELS NO
#define DEFAULT_SHOW_TICK_MARKS YES
#define DEFAULT_LOW_VALUE 0
#define DEFAULT_HIGH_VALUE 100
#define DEFAULT_CURRENT_VALUE 0.f
#define DEFAULT_LARGE_TICK_INTERVAL 10
#define DEFAULT_SHORT_TICKS_PER_LONG_TICK 4
#define DEFAULT_YELLOW_BOTTOM_VALUE 40
#define DEFAULT_YELLOW_TOP_VALUE 60
#define DEFAULT_CURRENT_BASELINE_VALUE 50
#define NUMBER_OF_WARNING_BAND_TICKS 31
#define NORMAL_GAUGE_WIDTH 300.0f
#define NORMAL_GAUGE_HEIGHT 300.0f
#define WARNING_BAND_DENSITY 0.6f
#define NORMAL_FONT_SIZE 16.0f
#define MIN_FONT_SIZE 10.0f
#define DEFAULT_MIN_DEGREES -120.0f
#define DEFAULT_MAX_DEGREES 120.0f
#define NORMAL_LONG_TICK_WIDTH 2.0f
#define NORMAL_LONG_TICK_HEIGHT 30.0f
#define NORMAL_LONG_TICK_START_RADIUS 110.0f
#define NORMAL_SHORT_TICK_WIDTH NORMAL_LONG_TICK_WIDTH
#define NORMAL_SHORT_TICK_HEIGHT (NORMAL_LONG_TICK_HEIGHT * 0.70f)
#define NORMAL_WARNING_BAND_HEIGHT 6.0f
#define NORMAL_WARNING_BAND_MARGIN 6.0f
#define NORMAL_PIN_RADIUS 20.0f

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

@interface DTGaugeView()
- (void)addNeedleSubview;
- (CGFloat)degreesForValue:(CGFloat)tickValue;
- (CGPoint)circularPositionForDegrees:(CGFloat)degrees atRadius:(CGFloat)radius;
- (void)resetTickLabels;
- (void)clearTickLabels;
- (void)drawLongTicks;
- (void)drawShortTicks;
- (void)drawWarningBands;
- (CGFloat)warningBandMarkInterval;
- (void)configureDefaultsWithFrame:(CGRect)theFrame;
- (CGFloat)scaleForCurrentBounds;
- (UIColor *)warningBandColorAtValue:(CGFloat)value;
- (void)adjustPinFrameForBounds;
- (void)adjustNeedleFrameForBounds;
- (void)rotateNeedleToValue:(CGFloat)value animated:(BOOL)animated;
- (void)fadeTickMarksIn;
- (void)fadeTickMarksOut;
- (void)fadeValueLabelsIn;
- (void)fadeValueLabelsOut;
- (void)fadeWarningBandsIn;
- (void)fadeWarningBandsOut;
@end


@implementation DTGaugeView
@synthesize currentValue, lowValue, highValue, largeTickInterval, minDegrees, maxDegrees, longTickWidth, longTickHeight, longTickStartRadius, shortTickWidth, shortTickStartRadius, shortTickHeight, shortTicksPerLongTick, tickLabels, needleView, pinView, tickLabelRadius, needleLength, pinRadius, gaugeMarkColor, warningBandGreenColor, warningBandYellowColor, warningBandRedColor, warningBandWidth, warningBandHeight, warningBandStartRadius, yellowBottomValue, yellowTopValue, currentBaselineValue;

- (void)dealloc {
	self.tickLabels = nil;
	self.needleView = nil;
	self.pinView = nil;
	self.gaugeMarkColor = nil;
	self.warningBandGreenColor = nil;
	self.warningBandYellowColor = nil;
	self.warningBandRedColor = nil;
	[super dealloc];
}

- (id)initWithFrame:(CGRect)theFrame {
	if ((self = [super initWithFrame:theFrame])) {
		[self configureDefaultsWithFrame:theFrame];
	}
	return self;
}

+ (id)viewWithFrame:(CGRect)theFrame {
	return [[[self alloc] initWithFrame:theFrame] autorelease];
}

#pragma mark NSObject

- (void)awakeFromNib {
	[self configureDefaultsWithFrame:self.frame];
}

#pragma mark UIView

- (void)drawRect:(CGRect)rect {
	if (self.showTickMarks) {
		[self drawLongTicks];
		[self drawShortTicks];
	}
	if (self.showWarningBands) {
		[self drawWarningBands];
	}
}

- (void)layoutSubviews {
	[self adjustNeedleFrameForBounds];
	[self adjustPinFrameForBounds];
	[super layoutSubviews];
}

#pragma mark Public

- (void)refreshNeedlePosition {
	[self rotateNeedleToValue:self.currentValue animated:YES];
}


#pragma mark Dynamic properties

- (BOOL)showTickMarks {
	return dtShowTickMarks;
}

- (void)setShowTickMarks:(BOOL)show {
	if (show && !dtShowTickMarks) {
		dtShowTickMarks = show;
		[self fadeTickMarksIn];
	}
	else if (!show && dtShowTickMarks) {
		dtShowTickMarks = show;
		[self fadeTickMarksOut];
	}
}

- (BOOL)showValueLabels {
	return dtShowValueLabels;
}

- (void)setShowValueLabels:(BOOL)show {
	if (show && !dtShowValueLabels) {
		dtShowValueLabels = show;
		[self fadeValueLabelsIn];
	}
	else if (!show && dtShowValueLabels) {
		dtShowValueLabels = show;
		[self fadeValueLabelsOut];
	}
}

- (BOOL)showWarningBands {
	return dtShowWarningBands;
}

- (void)setShowWarningBands:(BOOL)show {
	if (show && !dtShowWarningBands) {
		dtShowWarningBands = show;
		[self fadeWarningBandsIn];
	}
	else if (!show && dtShowWarningBands) {
		dtShowWarningBands = show;
		[self fadeWarningBandsOut];
	}
}

#pragma mark Private

- (void)addNeedleSubview {
	unless (self.needleView) {
		self.needleView = [UIImageView viewWithImage:[UIImage imageNamed:@"NeedleImage.png"]];
		[self adjustNeedleFrameForBounds];
		[self rotateNeedleToValue:lowValue animated:NO];
		[self addSubview:self.needleView];
	}	
}

- (void)addPinSubview {
	unless (self.pinView) {
		self.pinView = [UIImageView viewWithImage:[UIImage imageNamed:@"PinImage.png"]];
		[self adjustPinFrameForBounds];
		[self addSubview:self.pinView];
	}	
}

- (CGFloat)degreesForValue:(CGFloat)tickValue {
	return self.minDegrees + (self.maxDegrees - self.minDegrees) * ((tickValue - self.lowValue) / 
							  (self.highValue - self.lowValue));
}

- (CGPoint)circularPositionForDegrees:(CGFloat)degrees atRadius:(CGFloat)radius {
//	CGPoint centerPoint = CGPointMake([self scaledWidth] / 2, [self scaledHeight] / 2);
	CGPoint centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
	CGFloat xPosition = centerPoint.x + [self scaleForCurrentBounds] * radius * sin(DegreesToRadians(degrees));
	CGFloat yPosition = centerPoint.y + [self scaleForCurrentBounds] * radius * -cos(DegreesToRadians(degrees));
	return CGPointMake(xPosition, yPosition);
}

- (void)resetTickLabels {
	[self clearTickLabels];
	unless (self.tickLabels) {
		self.tickLabels = [NSMutableArray arrayWithCapacity:(self.highValue - self.lowValue) / self.largeTickInterval + 1];
	}
	if (self.showValueLabels) {
		for (CGFloat tickValue = self.lowValue; tickValue <= self.highValue; tickValue += self.largeTickInterval) {
			UILabel *newLabel = [UILabel labelWithText:$S(@"%d", (NSInteger)round(tickValue))];
			newLabel.font = [UIFont boldSystemFontOfSize:MAX(NORMAL_FONT_SIZE * [self scaleForCurrentBounds], MIN_FONT_SIZE)];
			newLabel.textColor = self.gaugeMarkColor;
			newLabel.backgroundColor = self.backgroundColor;
			[newLabel sizeToFit];
			CGFloat adjustedRadius = self.tickLabelRadius - ABS(sin(DegreesToRadians([self degreesForValue:tickValue])) * newLabel.width / 2);
			newLabel.center = [self circularPositionForDegrees:[self degreesForValue:tickValue] 
													  atRadius:adjustedRadius];
			[tickLabels addObject:newLabel];
			[self addSubview:newLabel];
		}
		[self.needleView.superview bringSubviewToFront:self.needleView];
		[self.pinView.superview bringSubviewToFront:self.pinView];
	}
}

- (void)clearTickLabels {
	while ([self.tickLabels count] > 0) {
		UILabel *oldLabel = [self.tickLabels lastObject];
		[self.tickLabels removeLastObject];
		[oldLabel removeFromSuperview];
	}
}

- (void)drawLongTicks {
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(myContext, self.gaugeMarkColor.red, gaugeMarkColor.green, gaugeMarkColor.blue, gaugeMarkColor.alpha);
	for (CGFloat tickValue = self.lowValue; tickValue <= self.highValue; tickValue += self.largeTickInterval) {
		CGFloat tickDegrees = [self degreesForValue:tickValue];
		CGContextSaveGState(myContext);
		CGContextScaleCTM(myContext, [self scaleForCurrentBounds], [self scaleForCurrentBounds]);
		CGContextTranslateCTM(myContext, NORMAL_GAUGE_WIDTH / 2, NORMAL_GAUGE_HEIGHT / 2);
		CGContextRotateCTM(myContext, DegreesToRadians(tickDegrees-180));
		CGContextFillRect (myContext, CGRectMake(-self.longTickWidth / 2, self.longTickStartRadius, self.longTickWidth, self.longTickHeight));
		CGContextRestoreGState(myContext);
	}
}

- (void)drawShortTicks {
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor (myContext, self.gaugeMarkColor.red, gaugeMarkColor.green, gaugeMarkColor.blue, gaugeMarkColor.alpha);
	NSInteger shortTickIndex = 0;
	for (CGFloat tickValue = self.lowValue; tickValue <= self.highValue; tickValue += self.largeTickInterval / (self.shortTicksPerLongTick + 1)) {
		if (fmod(shortTickIndex, self.shortTicksPerLongTick + 1) != 0) {
			CGFloat tickDegrees = [self degreesForValue:tickValue];
			CGContextSaveGState(myContext);
			CGContextScaleCTM(myContext, [self scaleForCurrentBounds], [self scaleForCurrentBounds]);
			CGContextTranslateCTM(myContext, NORMAL_GAUGE_WIDTH / 2, NORMAL_GAUGE_HEIGHT / 2);
			CGContextRotateCTM(myContext, DegreesToRadians(tickDegrees-180));
			CGContextFillRect (myContext, CGRectMake(-self.shortTickWidth / 2, self.shortTickStartRadius, self.shortTickWidth, self.shortTickHeight));		
			CGContextRestoreGState(myContext);
		}
		shortTickIndex++;
	}
}

- (void)drawWarningBands {
	CGContextRef myContext = UIGraphicsGetCurrentContext();
	for (CGFloat tickValue = self.lowValue; tickValue <= self.highValue + (self.highValue - self.lowValue) / (2 * (NUMBER_OF_WARNING_BAND_TICKS - 1)); tickValue += [self warningBandMarkInterval]) {
		CGFloat tickDegrees = [self degreesForValue:tickValue];
		CGContextSaveGState(myContext);
		CGContextScaleCTM(myContext, [self scaleForCurrentBounds], [self scaleForCurrentBounds]);
		CGContextTranslateCTM(myContext, NORMAL_GAUGE_WIDTH / 2, NORMAL_GAUGE_HEIGHT / 2);
		CGContextRotateCTM(myContext, DegreesToRadians(tickDegrees-180));
		UIColor *markColor = [self warningBandColorAtValue:tickValue];
		CGContextSetRGBFillColor (myContext, markColor.red, markColor.green, markColor.blue, markColor.alpha);
		CGContextFillRect (myContext, CGRectMake(-self.warningBandWidth / 2, self.warningBandStartRadius, self.warningBandWidth, self.warningBandHeight));		
		CGContextRestoreGState(myContext);
	}
}

- (CGFloat)warningBandMarkInterval {
	return (self.highValue - self.lowValue) / (NUMBER_OF_WARNING_BAND_TICKS - 1);
}

- (void)configureDefaultsWithFrame:(CGRect)theFrame {
	self.showTickMarks = DEFAULT_SHOW_TICK_MARKS;
	self.showValueLabels = DEFAULT_SHOW_VALUE_LABELS;
	self.showWarningBands = DEFAULT_SHOW_WARNING_BANDS;

	self.lowValue = DEFAULT_LOW_VALUE;
	self.highValue = DEFAULT_HIGH_VALUE;
	self.currentValue = DEFAULT_CURRENT_VALUE;
	self.largeTickInterval = DEFAULT_LARGE_TICK_INTERVAL;
	self.yellowBottomValue = DEFAULT_YELLOW_BOTTOM_VALUE;
	self.yellowTopValue = DEFAULT_YELLOW_TOP_VALUE;
	self.currentBaselineValue = DEFAULT_CURRENT_BASELINE_VALUE;
		
	self.warningBandHeight = NORMAL_WARNING_BAND_HEIGHT;
	self.warningBandStartRadius = NORMAL_GAUGE_WIDTH / 2 - self.warningBandHeight;
	self.longTickHeight = NORMAL_LONG_TICK_HEIGHT;
	self.longTickStartRadius = self.warningBandStartRadius - NORMAL_WARNING_BAND_MARGIN - self.longTickHeight;
	self.shortTickHeight = NORMAL_SHORT_TICK_HEIGHT;
	self.shortTickStartRadius = self.warningBandStartRadius - NORMAL_WARNING_BAND_MARGIN - self.shortTickHeight;
	self.tickLabelRadius = self.longTickStartRadius - NORMAL_FONT_SIZE / 2;
	self.needleLength = self.shortTickStartRadius + self.shortTickHeight / 2;
	self.pinRadius = NORMAL_PIN_RADIUS;
	
	self.minDegrees = DEFAULT_MIN_DEGREES;
	self.maxDegrees = DEFAULT_MAX_DEGREES;
	self.longTickWidth = NORMAL_LONG_TICK_WIDTH;
	self.shortTickWidth = NORMAL_SHORT_TICK_WIDTH;
	self.shortTicksPerLongTick = DEFAULT_SHORT_TICKS_PER_LONG_TICK;
	self.gaugeMarkColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
	self.warningBandGreenColor = [UIColor colorWithRed:0.3f green:0.6f blue:0.16f alpha:1.f];
	self.warningBandYellowColor = [UIColor colorWithRed:1.f green:0.98f blue:0.33f alpha:1.f];
	self.warningBandRedColor = [UIColor colorWithRed:0.91f green:0.38f blue:0.21f alpha:1.f];
//	self.warningBandWidth = [self scaleForCurrentBounds] * WARNING_BAND_DENSITY * M_PI * NORMAL_GAUGE_WIDTH * (self.maxDegrees - self.minDegrees) / 360.0 / (NUMBER_OF_WARNING_BAND_TICKS);
	self.warningBandWidth = ([self scaleForCurrentBounds] * WARNING_BAND_DENSITY * 
							 M_PI * NORMAL_GAUGE_WIDTH * 
							 (CGFloat)(self.maxDegrees - self.minDegrees) / 360.0 / 
							 (CGFloat)(NUMBER_OF_WARNING_BAND_TICKS-1));
	
	[self resetTickLabels];
	[self addNeedleSubview];
	[self addPinSubview];
	
	[self performSelector:@selector(refreshNeedlePosition) afterDelay:1.0f];
}

- (CGFloat)scaleForCurrentBounds {
	return self.bounds.size.width / 300.0;
}

- (UIColor *)warningBandColorAtValue:(CGFloat)value {
	if (value < self.yellowBottomValue) return self.warningBandGreenColor;
	else if (value <= self.yellowTopValue) return self.warningBandYellowColor;
	else return self.warningBandRedColor;
}

- (void)adjustPinFrameForBounds {
	if (self.pinView) {
		self.pinView.frame = CGRectMake(0.f, 0.f, self.pinRadius * 2 * [self scaleForCurrentBounds], self.pinRadius * 2 * [self scaleForCurrentBounds]);
		self.pinView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
	}
}

- (void)adjustNeedleFrameForBounds {
	if (self.needleView) {
		CGAffineTransform oldTransform = self.needleView.transform;
		self.needleView.transform = CGAffineTransformIdentity;
		self.needleView.frame = CGRectMake(0.f, 0.f, self.needleLength * 2 * [self scaleForCurrentBounds], self.needleLength * 2 * [self scaleForCurrentBounds]);
		self.needleView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		self.needleView.transform = oldTransform;
	}
}

- (void)rotateNeedleToValue:(CGFloat)value animated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:@"NeedleAnimation" context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2f];
	}
	self.needleView.transform = CGAffineTransformMakeRotation(DegreesToRadians([self degreesForValue:value]));
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)fadeTickMarksIn {
	[self setNeedsDisplay];
}

- (void)fadeTickMarksOut {
	[self setNeedsDisplay];
}

- (void)fadeValueLabelsIn {
	[self resetTickLabels];
}

- (void)fadeValueLabelsOut {
	[self resetTickLabels];
}

- (void)fadeWarningBandsIn {
	[self setNeedsDisplay];
}

- (void)fadeWarningBandsOut {
	[self setNeedsDisplay];
}

@end
