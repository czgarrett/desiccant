//
//  SQLiteColumn.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/5/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "SQLiteColumn.h"

@implementation SQLiteColumn

@synthesize name;
@synthesize typeName;

- (id)initWithName: (NSString *)newName typeName:(NSString *) sqliteType
{
   if ((self = [super init])) {
      self.name = newName;
      self.typeName = sqliteType;
   }
	return self;
}

@end
