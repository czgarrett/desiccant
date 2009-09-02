//
//  DTFiltersUntypedData.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DTFiltersUntypedData
- (BOOL)rejectsRow:(NSMutableDictionary *)row;
@end
