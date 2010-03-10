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

-(float)nextViewTop;

-(UIButton *)addButton:(NSString *)title action:(SEL)selector;
-(UILabel *)addLabelWithText: (NSString *)text usage: (UILabelUsage)usage;
-(UIActivityIndicatorView *)addActivityIndicator;
-(UIImageView *)addImageNamed:(NSString *)imageName;
-(UITextField *)addTextFieldWithPlaceholder:(NSString *)placeHolderText;
-(void)addContentView;
- (void)showAlertWithTitle: (NSString *)title message:(NSString *)message;
- (void)handleUnexpectedError: (NSError *) error;

// Provides an actionsheet-like mechanism for sliding simple views up over the 
// main view
- (void) slideViewUp: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background;
- (void) slideViewDown: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background;


@end