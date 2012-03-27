//
//  DTActivityIndicatorWithBackground.h
//  medaxion
//
//  Created by Garrett Christopher on 11/17/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTActivityIndicatorWithBackground : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIImage *iconImage;

- (void)showActivity;
- (void)showActivityWithText:(NSString *)text;
- (void)showIconImage;
- (void)showIconImageWithText:(NSString *)text;
- (void)hide;

@end
