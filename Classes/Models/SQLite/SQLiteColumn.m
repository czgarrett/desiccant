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
	self.name = newName;
	self.typeName = sqliteType;
	return self;
}

- (void)dealloc
{
   self.name = nil;
   self.typeName = nil;
   [super dealloc];
}

@end
