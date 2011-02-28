//
//  DTCustomTableViewCellTests.m
//  desiccant
//
//  Created by Christopher Garrett on 2/25/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTCustomTableViewCellTests.h"

#import "desiccant.h"

@implementation DTCustomTableViewCellTests

- (void)testBlock {
    
   DTCustomTableViewCell *cell = [[[DTCustomTableViewCell alloc] init] autorelease];
   cell.deleteBlock = ^(DTCustomTableViewCell *cell) {
     cell.textLabel.text = @"foo"; 
   };
    
}

@end
