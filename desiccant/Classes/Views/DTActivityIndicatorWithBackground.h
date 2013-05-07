//
//  DTActivityIndicatorWithBackground.h
//  medaxion
//
//  Created by Garrett Christopher on 11/17/11.
//  Copyright (c) 2011 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTActivityIndicatorWithBackground : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, weak) UIImage *iconImage;
@property (nonatomic, assign) CGFloat cornerRadius; //corner radius for the view background, default=10.0

// Configuring Title
- (void)setTitle:(NSString *)title;  //setter for the titleLabel text
- (NSString *)title;  //returns titleLabel.text
- (void)setFont:(UIFont *)font;

// View presentation and dismissal
- (void)showActivity;
- (void)showActivityWithTitle:(NSString *)text;
- (void)showIconImage;
- (void)showIconImageWithTitle:(NSString *)text;
- (void)hide;

@end
