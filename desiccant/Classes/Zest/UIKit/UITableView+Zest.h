//
//  UITableView+Zest.h
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Zest)
- (NSInteger) numberOfRowsAcrossAllSections;
- (CGFloat) cellWidth;
- (void) addInnerShadow;
@end
