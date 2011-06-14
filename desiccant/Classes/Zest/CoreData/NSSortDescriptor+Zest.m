//
//  NSSortDescriptor+Zest.m
//  WordTower
//
//  Created by Christopher Garrett on 2/6/10.
//  Copyright 2010 ZWorkbench, Inc.. All rights reserved.
//

#import "NSSortDescriptor+Zest.h"


@implementation NSSortDescriptor (Zest)

+ (NSSortDescriptor *) sortAscending: (NSString *) key {
   return [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];   
}

@end


@interface FixCategoryBugNSSortDescriptor : NSObject {}
@end
@implementation FixCategoryBugNSSortDescriptor
@end