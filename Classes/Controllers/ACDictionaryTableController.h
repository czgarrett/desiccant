//
//  ACDictionaryTableController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/6/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACDictionaryTableControllerDelegate.h"

@interface ACDictionaryTableController : UITableViewController <UITextFieldDelegate> {
   NSMutableDictionary *items;
   id <ACDictionaryTableControllerDelegate> delegate;
   UITableView *tableView;
}

@property (nonatomic, retain) NSMutableDictionary *items;
@property (nonatomic, retain) UITableView *tableView;

- (id) initWithDictionary: (NSMutableDictionary *) items delegate: (id <ACDictionaryTableControllerDelegate>) delegate;

- (void) saveItems: (id) source;
- (void) cancel: (id) source;
- (NSArray *) sectionNames;
- (NSString *) sectionName: (NSInteger) sectionIndex;
- (NSMutableArray *) itemsInSection: (NSInteger)sectionIndex;
- (NSString *) itemForIndexPath: (NSIndexPath *)path;


@end
