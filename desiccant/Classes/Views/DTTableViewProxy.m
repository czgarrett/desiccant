//
//  DTTableViewProxy.m
//
//  Created by Curtis Duhn on 11/11/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTTableViewProxy.h"
#import "DTCompositeTableViewControllerMapping.h"


@interface DTTableViewProxy()
@end

@implementation DTTableViewProxy
@synthesize containerTableView, mapping;

- (void)dealloc {
	self.mapping = nil;
	self.containerTableView = nil;
	
	
	[super dealloc];
}

#pragma mark Constructors

- (id)initWithContainerView:(UITableView *)theContainer mapping:(DTCompositeTableViewControllerMapping *)theMapping {
	if ((self = [super initWithFrame:theContainer.frame style:theContainer.style])) {
		self.containerTableView = theContainer;
		self.mapping = theMapping;
	}
	return self;
}

+ (id)proxyWithContainerView:(UITableView *)theContainer mapping:(DTCompositeTableViewControllerMapping *)theMapping {
	return [[[self alloc] initWithContainerView:theContainer mapping:theMapping] autorelease];
}


#pragma mark UITableView methods

// Uses default implementation for now.
//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
//	return [super initWithFrame:frame style:style];
//}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
	return [containerTableView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewStyle) style {
	return containerTableView.style;
}

// Uses default implementation for now.  Queries the data source.
//- (NSInteger)numberOfRowsInSection:(NSInteger)section {
//}

// Uses default implementation for now.  Queries the data source.
//- (NSInteger)numberOfSections {
//}

// ??? Should this proxy from the container
//- (CGFloat) rowHeight {
//}

// ??? Should this influence heightForRow:atIndexPath: in the container's controller?
//- (void) setRowHeight:(CGFloat) {
//}

// Default implementation for now
// @property(nonatomic) UITableViewCellSeparatorStyle separatorStyle

// Default implementation for now
//@property(nonatomic, retain) UIColor *separatorColor

// Default implementation for now
// Consider converting this into a section header in future version
//@property(nonatomic, retain) UIView *tableHeaderView

// Default implementation for now
// Consider converting this into a section footer in future version
//@property(nonatomic, retain) UIView *tableFooterView

// Default implementation for now
// ??? Should this influence tableView:heightForHeaderInSection:
//@property(nonatomic) CGFloat sectionHeaderHeight

// Default implementation for now
// ??? Should this influence tableView:heightForFooterInSection:
// @property(nonatomic) CGFloat sectionFooterHeight

// Default implementation for now
// @property(nonatomic) NSInteger sectionIndexMinimumDisplayRowCount

// Default implementation for now
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
	return [containerTableView indexPathForCell:cell];
}

- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point {
	return [containerTableView indexPathForRowAtPoint:point];
}

- (NSArray *)indexPathsForRowsInRect:(CGRect)rect {
	return [containerTableView indexPathsForRowsInRect:rect];
}

// Filters cells returned from container to only include index paths mapped to my data source
- (NSArray *)visibleCells {
	NSArray *containerCells = [containerTableView visibleCells];
	NSMutableArray *myCells = [NSMutableArray arrayWithCapacity:[containerCells count]];
	for (UITableViewCell *cell in containerCells) {
		if ([mapping containsAbsoluteIndexPath:[containerTableView indexPathForCell:cell]]) [myCells addObject:cell];
	}
	return myCells;
}

- (NSArray *)indexPathsForVisibleRows {
	NSArray *containerIndexPaths = [containerTableView indexPathsForVisibleRows];
	NSMutableArray *myIndexPaths = [NSMutableArray arrayWithCapacity:[containerIndexPaths count]];
	for (NSIndexPath *path in containerIndexPaths) {
		if ([mapping containsAbsoluteIndexPath:path]) [myIndexPaths addObject:[mapping controllerIndexPathForAbsoluteIndexPath:path]];
	}
	return myIndexPaths;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
	[containerTableView scrollToRowAtIndexPath:[mapping absoluteIndexPathForControllerIndexPath:indexPath] atScrollPosition:scrollPosition animated:animated];
}

- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
	[containerTableView scrollToNearestSelectedRowAtScrollPosition:scrollPosition animated:animated];
}

- (NSIndexPath *)indexPathForSelectedRow {
	NSIndexPath *indexPath = [containerTableView indexPathForSelectedRow];
	if ([mapping containsAbsoluteIndexPath:indexPath]) return [mapping controllerIndexPathForAbsoluteIndexPath:indexPath];
	else return nil;
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[containerTableView selectRowAtIndexPath:[mapping absoluteIndexPathForControllerIndexPath:indexPath] animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	[containerTableView deselectRowAtIndexPath:[mapping absoluteIndexPathForControllerIndexPath:indexPath] animated:NO];
}

// Default implementation for now.  Not proxied.
//@property(nonatomic) BOOL allowsSelection

// Default implementation for now.  Not proxied.
//@property(nonatomic) BOOL allowsSelectionDuringEditing

- (void)beginUpdates {
	[containerTableView beginUpdates];
}

- (void)endUpdates {
	[containerTableView endUpdates];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView insertRowsAtIndexPaths:[mapping absoluteIndexPathsForControllerIndexPaths:indexPaths] withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView deleteRowsAtIndexPaths:[mapping absoluteIndexPathsForControllerIndexPaths:indexPaths] withRowAnimation:animation];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView insertSections:[mapping absoluteSectionIndexSetForControllerSectionIndexSet:sections] withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView deleteSections:[mapping absoluteSectionIndexSetForControllerSectionIndexSet:sections] withRowAnimation:animation];
}

- (BOOL)isEditing {
	return [containerTableView isEditing];
}

- (void)setEditing:(BOOL)isEditing {
	[containerTableView setEditing:isEditing];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
	[containerTableView setEditing:editing animated:animate];
}

- (void)reloadData {
	[containerTableView reloadData];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView reloadRowsAtIndexPaths:[mapping absoluteIndexPathsForControllerIndexPaths:indexPaths] withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
	[containerTableView reloadSections:[mapping absoluteSectionIndexSetForControllerSectionIndexSet:sections] withRowAnimation:animation];
}

- (void)reloadSectionIndexTitles {
	[containerTableView reloadSectionIndexTitles];
}

- (CGRect)rectForSection:(NSInteger)section {
	if ([mapping proxiesSections]) return [containerTableView rectForSection:[mapping absoluteSectionForControllerSection:section]];
	else return CGRectZero;
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [containerTableView rectForRowAtIndexPath:[mapping absoluteIndexPathForControllerIndexPath:indexPath]];
}

- (CGRect)rectForFooterInSection:(NSInteger)section {
	if ([mapping proxiesSections]) return [containerTableView rectForFooterInSection:[mapping absoluteSectionForControllerSection:section]];
	else return CGRectZero;
}

- (CGRect)rectForHeaderInSection:(NSInteger)section {
	if ([mapping proxiesSections]) return [containerTableView rectForHeaderInSection:[mapping absoluteSectionForControllerSection:section]];
	else return CGRectZero;
}

@end
