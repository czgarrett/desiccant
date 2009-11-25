//
//  DTCompositeTableViewControllerMapping.h
//  CompositeTablesTest
//
//  Created by Curtis Duhn on 11/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@interface DTCompositeTableViewControllerMapping : NSObject {
	BOOL startsSection;
	BOOL proxiesSections;
	DTTableViewController *controller;
	NSString *headerTitle;
	NSString *footerTitle;
	NSString *indexTitle;
	DTCompositeTableViewControllerMapping *previousMapping;
	DTCompositeTableViewControllerMapping *nextMapping;
	NSUInteger myBaseSection;
	NSUInteger myBaseRow;
}

@property (nonatomic) BOOL startsSection;
@property (nonatomic) BOOL proxiesSections;
@property (nonatomic, retain) DTTableViewController *controller;
@property (nonatomic, retain) NSString *headerTitle;
@property (nonatomic, retain) NSString *footerTitle;
@property (nonatomic, retain) NSString *indexTitle;
@property (nonatomic, retain) DTCompositeTableViewControllerMapping *previousMapping;
@property (nonatomic, retain) DTCompositeTableViewControllerMapping *nextMapping;
@property (nonatomic) NSUInteger myBaseSection;
@property (nonatomic) NSUInteger myBaseRow;
@property (nonatomic, readonly) NSUInteger lastSection;
@property (nonatomic, readonly) NSUInteger lastRow;

- (id) initWithController:(DTTableViewController *)aController;
- (id) initWithController:(DTTableViewController *)aController proxiesSections:(BOOL)itProxiesSections;
- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle;
- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle;
- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle footerTitle:(NSString *)aFooterTitle;
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController;
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController proxiesSections:(BOOL)itProxiesSections;
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle;
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle;
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle footerTitle:(NSString *)aFooterTitle;

- (void)updateIndexPaths;
- (BOOL)containsAbsoluteIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)relativeIndexPathForAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath;
- (NSIndexPath *)absoluteIndexPathForControllerIndexPath:(NSIndexPath *)relativeIndexPath;
- (NSIndexPath *)controllerIndexPathForAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath;
- (NSInteger)numberOfRowsInAbsoluteSection:(NSInteger)section;
- (NSInteger)controllerSectionForAbsoluteSection:(NSInteger)absoluteSection;
- (NSUInteger)absoluteSectionForControllerSection:(NSUInteger)controllerSection;
- (BOOL)containsAbsoluteSection:(NSUInteger)absoluteSection;
- (NSIndexPath *)absoluteStartInsertionPath;
- (NSIndexPath *)absoluteEndInsertionPath;
- (NSInteger)numberOfSectionsStarted;
- (NSInteger)numberOfSectionsStartedOrContinued;
- (void)collectIndexTitles:(NSMutableArray *)titles;
- (NSInteger)tableView:(UITableView *)tableView controllerSectionForSectionIndexTitle:(NSString *)title atRelativeIndex:(NSInteger)titleIndex;
- (NSString *)titleForHeaderInAbsoluteSection:(NSInteger)section;
- (NSString *)titleForFooterInAbsoluteSection:(NSInteger)section;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)numberOfRowsInLastSection;
- (BOOL)containsAbsoluteRow:(NSUInteger)absoluteRow inAbsoluteSection:(NSUInteger)absoluteSection;
- (NSUInteger)firstAbsoluteProxiedSection;
- (NSArray *)absoluteIndexPathsForControllerIndexPaths:(NSArray *)controllerIndexPaths;
- (NSIndexSet *)absoluteSectionIndexSetForControllerSectionIndexSet:(NSIndexSet *)controllerSectionIndexSet;

@end
