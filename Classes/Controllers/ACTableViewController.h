//
//  ACListTableViewController.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 8/30/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARObject.h"
#import "ACModelObjectController.h"

#define CANCEL_BUTTON 0
#define OK_BUTTON 1


@interface ACTableViewController : UITableViewController <ACModelObjectController> {
   NSMutableArray *sections;
   NSMutableDictionary *items;
   NSMutableArray *sectionIndexTitles;
   
   ARObject *modelObject;   
   UIViewController <ACModelObjectController> *newItemController;
   UIViewController <ACModelObjectController> *editController;
   UIViewController <ACModelObjectController> *showController;

   // Optional filter control for list
   UISegmentedControl *filterControl;
   
   BOOL editable;
}

@property(nonatomic, retain) NSMutableDictionary *items;
@property(nonatomic, retain) NSMutableArray *sections;
@property(nonatomic, retain) NSMutableArray *sectionIndexTitles;
@property(nonatomic, retain) UIViewController <ACModelObjectController> *newItemController;
@property(nonatomic, retain) UIViewController <ACModelObjectController> *editController;
@property(nonatomic, retain) UIViewController <ACModelObjectController> *showController;
@property(nonatomic, retain) UISegmentedControl *filterControl;
@property(nonatomic, assign) BOOL editable;

// Filtering
- (void) addTitleFilterWithItems: (NSArray *)items;
- (void)filterAction:(id)sender;

// Selection
- (void)objectWasSelected: (NSObject *) selectedItem;

- (NSMutableArray *)itemsInSection:(NSInteger)section;
- (NSObject *)itemForIndexPath: (NSIndexPath *) indexPath;
- (void) setItems:(NSArray *)items forSection:(NSObject *)section;
- (BOOL) hasOneSection;
- (void) configureCell:(UITableViewCell *)cell;
- (void) populateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Editing stuff
- (NSString *) addTextForSection: (NSInteger) sectionIndex;
- (ARObject *) newModelObjectForSection: (NSInteger) sectionIndex;
- (UIViewController <ACModelObjectController> *) editorForIndexPath:(NSIndexPath *)indexPath;
- (BOOL) canAddItemsToSection: (NSInteger) section;
- (BOOL) canDeleteItemsInSection: (NSInteger) section;

// Alerts
- (void)alertWithTitle: (NSString *)title message: (NSString *)message;
- (void)confirmationWithTitle: (NSString *)title message: (NSString *)message;

// Sound
- (void) playSoundNamed: (NSString *)soundName;


@end
