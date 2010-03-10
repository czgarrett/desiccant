//
//  DTSortsUntypedData.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 3/10/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTSortsUntypedData
// Sort rows and return sorted mutable array.
- (NSMutableArray *)sortRows:(NSArray *)rows;
@end
