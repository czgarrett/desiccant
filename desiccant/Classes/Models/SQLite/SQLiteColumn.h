//
//  SQLiteColumn.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/5/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SQLiteColumn : NSObject {
	NSString *name;
	NSString *typeName;
}

@property (retain) NSString *name;
@property (retain) NSString *typeName;

- (id)initWithName: (NSString *)newName typeName:(NSString *) typeName;


@end
