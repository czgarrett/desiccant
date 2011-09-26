//
//  DTCompositeTableViewController.m
//
//  Created by Curtis Duhn on 11/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCompositeTableViewController.h"
#import "DTCompositeTableViewControllerMapping.h"
#import "DTTableViewProxy.h"

@interface DTCompositeTableViewController()
@property (nonatomic, retain) NSMutableArray *controllerMappings;
- (DTCompositeTableViewControllerMapping *)mappingForAbsoluteIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)mappingsForSection:(NSInteger)section;
- (DTCompositeTableViewControllerMapping *)tableView:(UITableView *)tableView mappingForSectionIndexTitleAtIndex:(NSInteger)titleIndex;
- (NSInteger)tableView:(UITableView *)tableView relativeIndexTitleIndexForAbsoluteIndexTitleIndex:(NSInteger)absoluteTitleIndex;
- (DTCompositeTableViewControllerMapping *)firstMappingForSectionWithAbsoluteIndex:(NSInteger)absoluteSectionIndex;
- (BOOL)controller:(DTTableViewController *)controllerA comesBeforeController:(DTTableViewController *)controllerB;
- (BOOL)selectorIsOptionalProxiedMethod:(SEL)aSelector;
- (BOOL)hasAChildControllerThatRespondsToSelector:(SEL)aSelector;
- (BOOL)hasAMappingThatSuppliesAValueForThisSelector:(SEL)aSelector;
- (BOOL)selectorHasBeenImplementedByASubclass:(SEL)aSelector;
- (void)forceTableViewToRescanForDataSourceAndDelegateMethods;
- (BOOL)selectorIsInfluencedByMappingsThatStartTheirOwnSections:(SEL)aSelector;
@end

@implementation DTCompositeTableViewController
@synthesize controllerMappings;

#pragma mark Memory Management methods
- (void)dealloc {
	self.controllerMappings = nil;

	[super dealloc];
}

#pragma mark Constructors
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.controllerMappings = [NSMutableArray arrayWithCapacity:3];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:style])) {
		self.controllerMappings = [NSMutableArray arrayWithCapacity:3];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		self.controllerMappings = [NSMutableArray arrayWithCapacity:3];
	}
	return self;
}

#pragma mark NSObject methods
- (BOOL) respondsToSelector:(SEL)aSelector {
	if ([self selectorIsOptionalProxiedMethod:aSelector]) {
		return ([self selectorHasBeenImplementedByASubclass:aSelector] || 
				  [self hasAMappingThatSuppliesAValueForThisSelector:aSelector] || 
				  [self hasAChildControllerThatRespondsToSelector:aSelector]);
	}
	else {
		return [super respondsToSelector:aSelector];
	}
}


#pragma mark DTTableViewController methods

- (void)viewDidLoad {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewDidLoad];
	}
	[super viewDidLoad];
}

- (void)viewDidUnload {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewDidUnload];
	}
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewWillAppear:animated];
	}
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewDidAppear:animated];
	}
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping.controller viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}

#pragma mark Public Methods

- (void)addControllerMapping:(DTCompositeTableViewControllerMapping *)mapping {
	mapping.previousMapping = [controllerMappings lastObject];
	((DTCompositeTableViewControllerMapping *)[controllerMappings lastObject]).nextMapping = mapping;
	[controllerMappings addObject:mapping];
	mapping.controller.containerTableViewController = self;
	mapping.controller.tableView = [DTTableViewProxy proxyWithContainerView:self.tableView mapping:mapping];
	[self forceTableViewToRescanForDataSourceAndDelegateMethods];
}

#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView cellForRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		NSAssert (0, @"Controller doesn't implement tableView:cellForRowAtIndexPath:");
		return nil;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger totalSections = 0;
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		totalSections += [mapping numberOfSectionsStarted];
		if (totalSections == 0) totalSections = 1;
	}
	return totalSections > 0 ? totalSections : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger totalRows = 0;
	for (DTCompositeTableViewControllerMapping *currentMapping in [self mappingsForSection:section]) {
		totalRows += [currentMapping numberOfRowsInAbsoluteSection:section]; 
	}
	return totalRows;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray *titles = [NSMutableArray arrayWithCapacity:8];
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping collectIndexTitles:titles];
	}
	return titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	DTCompositeTableViewControllerMapping *mapping = [self tableView:tableView mappingForSectionIndexTitleAtIndex:index];
	if (mapping) return [mapping absoluteSectionForControllerSection:[mapping tableView:tableView 
																		controllerSectionForSectionIndexTitle:title 
																								  atRelativeIndex:[self tableView:tableView relativeIndexTitleIndexForAbsoluteIndexTitleIndex:index]]];
	else return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	return [mapping titleForHeaderInAbsoluteSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	return [mapping titleForFooterInAbsoluteSection:section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	DTCompositeTableViewControllerMapping *fromMapping = [self mappingForAbsoluteIndexPath:fromIndexPath];
	DTCompositeTableViewControllerMapping *toMapping = [self mappingForAbsoluteIndexPath:toIndexPath];
	if (fromMapping.controller == toMapping.controller && [fromMapping.controller respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
		[fromMapping.controller tableView:tableView moveRowAtIndexPath:[fromMapping controllerIndexPathForAbsoluteIndexPath:fromIndexPath] toIndexPath:[fromMapping controllerIndexPathForAbsoluteIndexPath:toIndexPath]];
	}
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView heightForRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return mapping.controller.tableView.rowHeight;
	}
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView indentationLevelForRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return 0;		
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)aCell forRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView willDisplayCell:aCell forRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
		[mapping.controller tableView:tableView accessoryButtonTappedForRowWithIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

#ifndef __IPHONE_3_0
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]) {
		return [mapping.controller tableView:tableView accessoryTypeForRowWithIndexPath:[self controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return UITableViewCellAccessoryNone
	}
}
#endif

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
		return [mapping absoluteIndexPathForControllerIndexPath:[mapping.controller tableView:tableView 
																		willSelectRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]]];
	}
	else {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView didSelectRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
		return [mapping absoluteIndexPathForControllerIndexPath:[mapping.controller tableView:tableView 
																	 willDeselectRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]]];
	}
	else {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView didDeselectRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	if ([mapping.controller respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
		return [mapping.controller tableView:tableView viewForHeaderInSection:[mapping controllerSectionForAbsoluteSection:section]];
	}
	else {
		return nil;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	if ([mapping.controller respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {	
		return [mapping.controller tableView:tableView viewForFooterInSection:[mapping controllerSectionForAbsoluteSection:section]];
	}
	else {
		return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	if ([mapping.controller respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
		return [mapping.controller tableView:tableView heightForHeaderInSection:[mapping controllerSectionForAbsoluteSection:section]];
	}
	else {
		return [mapping.controller.tableView sectionHeaderHeight];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	DTCompositeTableViewControllerMapping *mapping = [self firstMappingForSectionWithAbsoluteIndex:section];
	if ([mapping.controller respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
		return [mapping.controller tableView:tableView heightForFooterInSection:[mapping controllerSectionForAbsoluteSection:section]];
	}
	else {
		return mapping.controller.tableView.sectionFooterHeight;
	}
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView willBeginEditingRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
		[mapping.controller tableView:tableView didEndEditingRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView editingStyleForRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return UITableViewCellEditingStyleNone;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return @"Delete";
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	DTCompositeTableViewControllerMapping *mapping = [self mappingForAbsoluteIndexPath:indexPath];
	if ([mapping.controller respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
		return [mapping.controller tableView:tableView shouldIndentWhileEditingRowAtIndexPath:[mapping controllerIndexPathForAbsoluteIndexPath:indexPath]];
	}
	else {
		return YES;
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	DTCompositeTableViewControllerMapping *fromMapping = [self mappingForAbsoluteIndexPath:sourceIndexPath];
	DTCompositeTableViewControllerMapping *toMapping = [self mappingForAbsoluteIndexPath:proposedDestinationIndexPath];
	if (fromMapping.controller == toMapping.controller && [fromMapping.controller respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
		return [fromMapping absoluteIndexPathForControllerIndexPath:[fromMapping.controller tableView:tableView 
																			targetIndexPathForMoveFromRowAtIndexPath:[fromMapping controllerIndexPathForAbsoluteIndexPath:sourceIndexPath] 
																										toProposedIndexPath:[fromMapping controllerIndexPathForAbsoluteIndexPath:proposedDestinationIndexPath]]];
	}
	else {
		if ([self controller:toMapping.controller comesBeforeController:fromMapping.controller]) {
			return [fromMapping absoluteStartInsertionPath];
		}
		else {
			return [fromMapping absoluteEndInsertionPath];
		}
	}
}

#pragma mark Private Methods

- (DTCompositeTableViewControllerMapping *)mappingForAbsoluteIndexPath:(NSIndexPath *)indexPath {
	for (DTCompositeTableViewControllerMapping *currentMapping in controllerMappings) {
		[currentMapping updateIndexPaths];
		if ([currentMapping containsAbsoluteIndexPath:indexPath])
		{
			return currentMapping;
		}
	}
	NSAssert1 (0, @"mappingForAbsoluteIndexPath: couldn't find a mapping for %@.", [indexPath description]);
	return nil;
}

- (void)forceTableViewToRescanForDataSourceAndDelegateMethods {
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

- (BOOL)selectorHasBeenImplementedByASubclass:(SEL)aSelector {
	return [self methodForSelector:aSelector] != [DTCompositeTableViewController instanceMethodForSelector:aSelector];
}

- (BOOL)selectorIsOptionalProxiedMethod:(SEL)aSelector {
	return (aSelector == @selector(sectionIndexTitlesForTableView:)			  
			  || aSelector == @selector(tableView:sectionForSectionIndexTitle:atIndex:)
			  || aSelector == @selector(tableView:titleForHeaderInSection:)
			  || aSelector == @selector(tableView:titleForFooterInSection:)
			  || aSelector == @selector(tableView:commitEditingStyle:forRowAtIndexPath:)
			  || aSelector == @selector(tableView:moveRowAtIndexPath:toIndexPath:)
			  || aSelector == @selector(tableView:heightForRowAtIndexPath:)
			  || aSelector == @selector(tableView:indentationLevelForRowAtIndexPath:)
			  || aSelector == @selector(tableView:willDisplayCell:forRowAtIndexPath:)
			  || aSelector == @selector(tableView:heightForFooterInSection:)
			  || aSelector == @selector(tableView:accessoryButtonTappedForRowWithIndexPath:)
			  || aSelector == @selector(tableView:accessoryTypeForRowWithIndexPath:)
			  || aSelector == @selector(tableView:willSelectRowAtIndexPath:)
			  || aSelector == @selector(tableView:didSelectRowAtIndexPath:)
			  || aSelector == @selector(tableView:willDeselectRowAtIndexPath:)
			  || aSelector == @selector(tableView:didDeselectRowAtIndexPath:)
			  || aSelector == @selector(tableView:viewForHeaderInSection:)
			  || aSelector == @selector(tableView:viewForFooterInSection:)
			  || aSelector == @selector(tableView:heightForHeaderInSection:)
			  || aSelector == @selector(tableView:heightForFooterInSection:)
			  || aSelector == @selector(tableView:willBeginEditingRowAtIndexPath:)
			  || aSelector == @selector(tableView:didEndEditingRowAtIndexPath:)
			  || aSelector == @selector(tableView:editingStyleForRowAtIndexPath:)
			  || aSelector == @selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)
			  || aSelector == @selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)
			  || aSelector == @selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)
			  );
}

- (BOOL)hasAChildControllerThatRespondsToSelector:(SEL)aSelector {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		if ([mapping.controller respondsToSelector:aSelector]) return YES;
	}
	return NO;
}

- (BOOL)selectorIsInfluencedByMappingsThatStartTheirOwnSections:(SEL)aSelector {
	return (aSelector == @selector(sectionIndexTitlesForTableView:)
			  || aSelector == @selector(tableView:sectionForSectionIndexTitle:atIndex:)
			  || aSelector == @selector(tableView:titleForHeaderInSection:)
			  || aSelector == @selector(tableView:titleForFooterInSection:)
			  );
}

- (BOOL)hasAMappingThatSuppliesAValueForThisSelector:(SEL)aSelector {
	if ([self selectorIsInfluencedByMappingsThatStartTheirOwnSections:aSelector]) {
		BOOL hasAMappingThatProvidesAHeaderTitle = NO;
		BOOL hasAMappingThatProvidesAFooterTitle = NO;
		BOOL hasAMappingThatProvidesAnIndexTitle = NO;
		for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
			if (mapping.startsSection) {
				if (mapping.headerTitle) hasAMappingThatProvidesAHeaderTitle = YES;
				if (mapping.footerTitle) hasAMappingThatProvidesAFooterTitle = YES;
				if (mapping.indexTitle) hasAMappingThatProvidesAnIndexTitle = YES;
			}
		}
		return ((aSelector == @selector(sectionIndexTitlesForTableView:) && hasAMappingThatProvidesAnIndexTitle) ||
				  (aSelector == @selector(tableView:sectionForSectionIndexTitle:atIndex:) && hasAMappingThatProvidesAnIndexTitle) ||
				  (aSelector == @selector(tableView:titleForHeaderInSection:) && hasAMappingThatProvidesAHeaderTitle) ||
				  (aSelector == @selector(tableView:titleForFooterInSection:) && hasAMappingThatProvidesAFooterTitle));
	}
	return NO;
}

- (NSArray *)mappingsForSection:(NSInteger)section {
	NSMutableArray *mappings = [NSMutableArray arrayWithCapacity:8];
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping updateIndexPaths];
		if (mapping.myBaseSection > section) break;
		if (section >= mapping.myBaseSection && section <= mapping.lastSection) [mappings addObject:mapping];
	}
	return mappings;
}

- (DTCompositeTableViewControllerMapping *)tableView:(UITableView *)tableView mappingForSectionIndexTitleAtIndex:(NSInteger)titleIndex {
	NSAssert ([controllerMappings count] > 0, @"Error: Attemping to use DTCompositeTableViewController with no mappings defined.");
	NSInteger titlesFoundSoFar = 0;
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping updateIndexPaths];
		NSArray *titles = [mapping sectionIndexTitlesForTableView:tableView];
		titlesFoundSoFar += [titles count];
		if (titlesFoundSoFar > titleIndex) return mapping;
	}
	NSAssert2 (0, @"DTCompositeTableViewController requested section index title at index %d, but only %d index titles were found.", titleIndex, titlesFoundSoFar);
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView relativeIndexTitleIndexForAbsoluteIndexTitleIndex:(NSInteger)absoluteTitleIndex {
	NSInteger titlesFoundSoFar = 0;
	NSInteger firstAbsoluteTitleIndexForThisMapping = 0;
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		NSArray *titles = [mapping sectionIndexTitlesForTableView:tableView];
		titlesFoundSoFar += [titles count];
		if (titlesFoundSoFar > absoluteTitleIndex) return absoluteTitleIndex - firstAbsoluteTitleIndexForThisMapping;
		firstAbsoluteTitleIndexForThisMapping += [titles count];
	}
	
	NSAssert2 (0, @"tableView:relativeIndexTitleIndexForAbsoluteTitleIndex: requested relative index for absolute index %d, but only %d index titles were found.", absoluteTitleIndex, titlesFoundSoFar);
	return 0;
}

- (DTCompositeTableViewControllerMapping *)firstMappingForSectionWithAbsoluteIndex:(NSInteger)absoluteSectionIndex {
	NSAssert ([controllerMappings count] > 0, @"Error: Attemping to use DTCompositeTableViewController with no mappings defined.");
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		[mapping updateIndexPaths];
		if ([mapping containsAbsoluteSection:absoluteSectionIndex]) return mapping;
	}
	NSAssert1 (0, @"firstMappingForSectionWithAbsoluteIndex: requested mapping for section with index %d, we don't have that many sections.", absoluteSectionIndex);
	return nil;
}

- (BOOL)controller:(DTTableViewController *)controllerA comesBeforeController:(DTTableViewController *)controllerB {
	for (DTCompositeTableViewControllerMapping *mapping in controllerMappings) {
		if (mapping.controller == controllerA) return YES;
		else if (mapping.controller == controllerB) return NO;
	}
	return NO;
}

@end
