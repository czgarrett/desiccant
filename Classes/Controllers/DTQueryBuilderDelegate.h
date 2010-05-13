//
//  DTQueryBuilderDelegate.h
//
//  Created by Curtis Duhn on 11/12/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTQueryBuilderElement.h"
#import "DTQueryBuilderCell.h"

@class DTQueryBuilder;
@protocol DTQueryBuilderCell;
@protocol DTQueryBuilderElement;
@protocol DTQueryBuilderElementType;
@protocol DTQueryBuilderDelegate

@required
- (UITableViewCell <DTQueryBuilderCell> *)queryBuilder:(DTQueryBuilder *)builder newInputCellForTableView:(UITableView *)tableView;
- (UITableViewCell <DTQueryBuilderCell> *)queryBuilder:(DTQueryBuilder *)builder tableView:(UITableView *)tableView cellForQueryElement:(NSObject <DTQueryBuilderElement> *)element;
- (NSInteger)numberOfElementsForQueryBuilder:(DTQueryBuilder *)builder;
- (NSObject <DTQueryBuilderElement> *)queryBuilder:(DTQueryBuilder *)builder elementAtIndex:(NSInteger)index;
- (NSArray *)queryBuilder:(DTQueryBuilder *)builder typesForElementAtIndex:(NSInteger)elementIndex;
- (BOOL)queryBuilder:(DTQueryBuilder *)builder didFinishEditingElementAtIndex:(NSInteger)elementIndex withText:(NSString *)text type:(NSObject <DTQueryBuilderElementType> *)type;
- (void)queryBuilder:(DTQueryBuilder *)builder deleteElementAtIndex:(NSInteger)elementIndex;

@optional
- (BOOL)queryBuilder:(DTQueryBuilder *)builder type:(NSObject <DTQueryBuilderElementType> *)type isValidForText:(NSString *)text atIndex:(NSInteger)index;
- (BOOL)queryBuilder:(DTQueryBuilder *)builder type:(NSObject <DTQueryBuilderElementType> *)type canStartWithText:(NSString *)text atIndex:(NSInteger)index;
- (BOOL)newInputCellShouldBeShownByQueryBuilder:(DTQueryBuilder *)builder;
- (void)queryBuilder:(DTQueryBuilder *)builder willStartEditingElementAtIndex:(NSInteger)elementIndex;
- (void)queryBuilder:(DTQueryBuilder *)builder didCancelEditingElementAtIndex:(NSInteger)elementIndex;

@end
