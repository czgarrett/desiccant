//
//  SQLiteTable.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/5/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteColumn.h"

@interface SQLiteTable : NSObject {
	NSString *name;
	NSMutableDictionary *columns;
}

- (id) initWithName:(NSString *)name;
- (SQLiteColumn *)columnNamed: (NSString *)name;
- (NSEnumerator *)columnEnumerator;
- (NSArray *)columnNames;

@end
