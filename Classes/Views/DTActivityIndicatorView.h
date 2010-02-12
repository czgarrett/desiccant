//
//  DTActivityIndicatorView.h
//  PortablePTO
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

// This class should behave the same as UIActivityIndicatorView, except for a couple differences:
// 1. When it gets resized, the spinner should stay the same size and get centered within the new frame.
// 2. It counts the calls to startAnimating, and requires an equal number of calls to stopAnimating before it will actually stop.
//    This way you can have a controller running multiple concurrent queries, and the spinner will only stop when all
//    have completed.
@interface DTActivityIndicatorView : UIView {
	UIActivityIndicatorView *childIndicator;
	NSInteger activityCount;
	BOOL hidesWhenStopped;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@property (nonatomic) BOOL hidesWhenStopped;
@property UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
