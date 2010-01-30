//
//  UIButton+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/22/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

typedef enum {
   UILabelUsageHeading = 0,
   UILabelUsageSubheading,
   UILabelUsageProgress,
   UILabelUsageInfo,
   UILabelUsageWarning
} UILabelUsage;

@interface UIViewController ( Zest )

// If this controller participates in a tabbed and or navigation hierarchy, this property
// will return the UIViewController that is currently showing (i.e. selected tab and/or top of the nav stack).
@property (nonatomic, retain, readonly) UIViewController *foregroundViewController;

-(float)nextViewTop;

-(UIButton *)addButton:(NSString *)title action:(SEL)selector;
-(UILabel *)addLabelWithText: (NSString *)text usage: (UILabelUsage)usage;
-(UIActivityIndicatorView *)addActivityIndicator;
-(UIImageView *)addImageNamed:(NSString *)imageName;
-(UITextField *)addTextFieldWithPlaceholder:(NSString *)placeHolderText;
-(void)addContentView;
- (void)errorAlertTitle: (NSString *)title message:(NSString *)message;
- (void)alertWithTitle: (NSString *)title message: (NSString *)message;
- (void)confirmationWithTitle: (NSString *)title message: (NSString *)message;
- (CGRect)fullScreenViewBounds;

@end