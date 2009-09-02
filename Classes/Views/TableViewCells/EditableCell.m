//
//  EditableCell.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/7/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import "EditableCell.h"


@implementation EditableCell
@synthesize textField, indexPath;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
   if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
      // Set the frame to CGRectZero as it will be reset in layoutSubviews
      textField = [[UITextField alloc] initWithFrame:CGRectZero];
      textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      textField.font = [UIFont boldSystemFontOfSize:14.0];
      textField.textColor = [UIColor blackColor];
      textField.returnKeyType = UIReturnKeyDone;
      [self.contentView addSubview:textField];
   }
   return self;
}


- (void) setText: (NSString *) newText {
   textField.text = newText;
}

- (NSString *) text {
   return textField.text;
}


- (void)dealloc {
   self.textField = nil;
   [super dealloc];
}

- (void)layoutSubviews {
   [super layoutSubviews];
   // Start with a rect that is inset from the content view by 10 pixels on all sides.
   self.textField.frame = CGRectInset(self.contentView.bounds, 10, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
   [super setSelected:selected animated:animated];
   // Update text color so that it matches expected selection behavior.
   if (selected) {
      textField.textColor = [UIColor whiteColor];
   } else {
      textField.textColor = [UIColor darkGrayColor];
   }
}



@end
