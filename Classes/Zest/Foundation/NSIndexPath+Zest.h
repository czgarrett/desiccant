//
//  NSIndexPath+Zest.h
//
//  Created by Curtis Duhn on 11/7/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (Zest)
- (NSIndexPath *)relativeIndexPathWithBaseSection:(NSUInteger)baseSection andBaseRow:(NSUInteger)baseRow;
@end
