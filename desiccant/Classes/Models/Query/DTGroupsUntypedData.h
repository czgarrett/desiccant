//
//  DTGroupsUntypedData.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/22/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTGroupsUntypedData

- (void)groupRows:(NSArray *)rows into:(NSMutableArray *)groups;

@end
