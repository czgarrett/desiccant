//
//  DTCompositeTableViewControllerMapping.m
//  CompositeTablesTest
//
//  Created by Curtis Duhn on 11/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTCompositeTableViewControllerMapping.h"
#import "Zest.h"

@interface DTCompositeTableViewControllerMapping()
- (NSIndexPath *)expandedRelativeIndexPathForFlattenedAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath withBaseSection:(NSUInteger)baseSection andBaseRow:(NSUInteger)baseRow;
@end

@implementation DTCompositeTableViewControllerMapping
@synthesize startsSection, proxiesSections, controller, headerTitle, footerTitle, indexTitle, previousMapping, nextMapping, myBaseSection, myBaseRow;

#pragma mark Memory Management methods
- (void)dealloc {
	self.controller = nil;
	self.headerTitle = nil;
	self.footerTitle = nil;
	self.indexTitle = nil;
	self.previousMapping = nil;
	self.nextMapping = nil;
	
	[super dealloc];
}

#pragma mark Constructors

- (id) initWithController:(DTTableViewController *)aController {
	if (self = [self initWithController:aController proxiesSections:NO]) {
	}
	return self;
}

- (id) initWithController:(DTTableViewController *)aController proxiesSections:(BOOL)itProxiesSections {
	if (self = [super init]) {
		self.controller = aController;
		self.proxiesSections = itProxiesSections;
		self.startsSection = NO;
	}
	return self;
}

- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle {
	return [self initWithController:aController startsSectionWithHeaderTitle:aHeaderTitle indexTitle:nil footerTitle:nil];
}

- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle {
	return [self initWithController:aController startsSectionWithHeaderTitle:aHeaderTitle indexTitle:anIndexTitle footerTitle:nil];
}

- (id) initWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle footerTitle:(NSString *)aFooterTitle {
	if (self = [super init]) {
		self.controller = aController;
		self.proxiesSections = NO;
		self.startsSection = (aHeaderTitle || anIndexTitle || aFooterTitle);
		self.headerTitle = aHeaderTitle;
		self.indexTitle = anIndexTitle;
		self.footerTitle = aFooterTitle;
	}
	return self;
}

+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController {
	return [[[self alloc] initWithController:aController] autorelease];
}
+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController proxiesSections:(BOOL)itProxiesSections {
	return [[[self alloc] initWithController:aController proxiesSections:itProxiesSections] autorelease];
}

+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle {
	return [[[self alloc] initWithController:aController startsSectionWithHeaderTitle:aHeaderTitle] autorelease];
}

+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle {
	return [[[self alloc] initWithController:aController startsSectionWithHeaderTitle:aHeaderTitle indexTitle:anIndexTitle] autorelease];
}

+ (DTCompositeTableViewControllerMapping *)mappingWithController:(DTTableViewController *)aController startsSectionWithHeaderTitle:(NSString *)aHeaderTitle indexTitle:(NSString *)anIndexTitle footerTitle:(NSString *)aFooterTitle {
	return [[[self alloc] initWithController:aController startsSectionWithHeaderTitle:aHeaderTitle indexTitle:anIndexTitle] autorelease];
}

#pragma mark Public methods

- (void)updateIndexPaths {
	if (previousMapping) {
		if (startsSection || proxiesSections) {
			myBaseSection = previousMapping.lastSection + 1;
			myBaseRow = 0;
		}
		else {
			myBaseSection = previousMapping.lastSection;
			myBaseRow = previousMapping.lastRow + 1;
		}
	}
	else {
		myBaseSection = 0;
		myBaseRow = 0;
	}
}

- (NSUInteger)lastSection {
	return myBaseSection + [self numberOfSectionsStartedOrContinued] - 1;
}

- (NSUInteger)lastRow {
	if (proxiesSections) return [self numberOfRowsInLastSection];
	else return myBaseRow + [controller numberOfRowsAcrossAllSectionsInTableView:controller.tableView];
}

- (BOOL)containsAbsoluteIndexPath:(NSIndexPath *)indexPath {
	return ([self containsAbsoluteSection:indexPath.section] && 
			  [self containsAbsoluteRow:indexPath.row 
						 inAbsoluteSection:indexPath.section]);
}

- (NSUInteger)firstAbsoluteProxiedSection {
	NSAssert (proxiesSections, @"Requested firstAbsoluteProxiedSection from a mapping that doesn't proxy sections.");
	if (startsSection) return myBaseSection + 1;
	else return myBaseSection;
}

- (NSIndexPath *)relativeIndexPathForAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath {
	if (proxiesSections) {
		return [absoluteIndexPath relativeIndexPathWithBaseSection:myBaseSection andBaseRow:myBaseRow];
	}
	else {
		return [self expandedRelativeIndexPathForFlattenedAbsoluteIndexPath:absoluteIndexPath withBaseSection:myBaseSection andBaseRow:myBaseRow];
	}
}

- (NSIndexPath *)controllerIndexPathForAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath {
	if (proxiesSections) {
		return [absoluteIndexPath relativeIndexPathWithBaseSection:[self firstAbsoluteProxiedSection] andBaseRow:myBaseRow];
	}
	else {
		return [self expandedRelativeIndexPathForFlattenedAbsoluteIndexPath:absoluteIndexPath withBaseSection:myBaseSection andBaseRow:myBaseRow];
	}
}

- (NSIndexPath *)absoluteIndexPathForControllerIndexPath:(NSIndexPath *)controllerIndexPath {
	return [NSIndexPath indexPathForRow:myBaseRow + controllerIndexPath.row inSection:[self absoluteSectionForControllerSection:controllerIndexPath.section]];
}

- (NSInteger)numberOfRowsInAbsoluteSection:(NSInteger)absoluteSection {
	if (proxiesSections) {
		if (startsSection && absoluteSection == myBaseSection) return 0;
		else {
			NSAssert2 (absoluteSection <= self.lastSection, @"Requested number of rows in absolute section %d from a mapping with a last section of %d", absoluteSection, self.lastSection);
			return [controller tableView:controller.tableView numberOfRowsInSection:[self controllerSectionForAbsoluteSection:absoluteSection]];
		}
	}
	else {
		NSAssert2 (absoluteSection == myBaseSection, @"Requested number of rows in absolute section %d from a mapping that doesn't proxy sections.  Only section %d is valid.", absoluteSection, myBaseSection);
		return [controller numberOfRowsAcrossAllSectionsInTableView:controller.tableView];
	}
}

- (NSInteger)controllerSectionForAbsoluteSection:(NSInteger)absoluteSection {
	NSAssert2 (absoluteSection <= self.lastSection, @"Absolute section %d greater than last section %d", absoluteSection, self.lastSection);
	if (startsSection && proxiesSections) {
		NSAssert (absoluteSection > myBaseSection, @"A mapping that proxies sections and starts a section can't return a controller section its base section");
		return absoluteSection - (myBaseSection + 1);
	}
	else if (proxiesSections) {
		return absoluteSection - myBaseSection;
	}
	else {
		NSAssert (absoluteSection == myBaseSection, @"The base section is the only valid absolute section for a mapping that doesn't proxy sections.");
		return myBaseSection;
	}
}

- (NSUInteger)absoluteSectionForControllerSection:(NSUInteger)controllerSection {
	if (proxiesSections) return myBaseSection + controllerSection;
	else return myBaseSection;
}

- (BOOL)containsAbsoluteSection:(NSUInteger)absoluteSection {
	NSAssert2 (absoluteSection >= myBaseSection, @"Testing for absolute section %d, which is less than base section %d", absoluteSection, myBaseSection);
	return (absoluteSection - myBaseSection + 1 <= [self numberOfSectionsStartedOrContinued]);
}

- (NSInteger)numberOfSectionsStarted {
	NSInteger numberOfSections = 0;
	if (startsSection) numberOfSections += 1;
	if (proxiesSections) numberOfSections += [controller numberOfSectionsInTableView:controller.tableView];
	return numberOfSections;
}

- (NSInteger)numberOfSectionsStartedOrContinued {
	NSInteger sectionsStarted = [self numberOfSectionsStarted];
	if (sectionsStarted > 0) return sectionsStarted;
	else return 1;
}

- (void)collectIndexTitles:(NSMutableArray *)titles {
	if (startsSection && indexTitle) [titles addObject:indexTitle];
	if (proxiesSections && [controller respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
		[titles addObjectsFromArray:[controller sectionIndexTitlesForTableView:controller.tableView]];
	}
}

- (NSInteger)numberOfRowsInLastSection {
	if (proxiesSections) return [controller tableView:controller.tableView numberOfRowsInSection:[controller numberOfSectionsInTableView:controller.tableView] - 1];
	else return [controller numberOfRowsAcrossAllSectionsInTableView:controller.tableView];
}

- (BOOL)containsAbsoluteRow:(NSUInteger)absoluteRow inAbsoluteSection:(NSUInteger)absoluteSection {
	return ([self containsAbsoluteSection:absoluteSection] &&
			  absoluteRow >= myBaseRow &&
			  absoluteRow - myBaseRow < [self numberOfRowsInAbsoluteSection:absoluteSection]);
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray *titles = [NSMutableArray arrayWithCapacity:1];
	if (startsSection && indexTitle) [titles addObject:indexTitle];
	if (proxiesSections && [controller respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
		[titles addObjectsFromArray:[controller sectionIndexTitlesForTableView:controller.tableView]];
	}
	return titles;
}

- (NSString *)titleForHeaderInAbsoluteSection:(NSInteger)absoluteSection {
	if (startsSection && absoluteSection == myBaseSection) return self.headerTitle;
	else if (proxiesSections && [controller respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return [controller tableView:controller.tableView titleForHeaderInSection:[self controllerSectionForAbsoluteSection:absoluteSection]];
	}
	else return self.headerTitle;
}

- (NSString *)titleForFooterInAbsoluteSection:(NSInteger)absoluteSection {
	if (startsSection && absoluteSection == myBaseSection) return self.footerTitle;
	else if (proxiesSections && [controller respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
		return [controller tableView:controller.tableView titleForFooterInSection:[self controllerSectionForAbsoluteSection:absoluteSection]];
	}
	else return self.footerTitle;
}

- (NSInteger)tableView:(UITableView *)tableView controllerSectionForSectionIndexTitle:(NSString *)title atRelativeIndex:(NSInteger)titleIndex {
	NSInteger relativeSection = 0;
	if (startsSection && indexTitle) {
		if (titleIndex == 0) return 0;
		else titleIndex -= 1;
	}
	if (proxiesSections && [controller respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
		relativeSection = [controller tableView:tableView sectionForSectionIndexTitle:title atIndex:titleIndex];
		if (startsSection) relativeSection += 1;
	}
	return relativeSection;
}

- (NSIndexPath *)absoluteStartInsertionPath {
	return [NSIndexPath indexPathForRow:myBaseRow inSection:myBaseSection];
}

- (NSIndexPath *)absoluteEndInsertionPath {
	NSUInteger section = self.lastSection;
	NSUInteger row;
	if (self.startsSection) row = [controller numberOfRowsAcrossAllSectionsInTableView:controller.tableView];
	else if (self.proxiesSections) row = [self numberOfRowsInLastSection];
	else row = myBaseRow + [controller numberOfRowsAcrossAllSectionsInTableView:controller.tableView];
	return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSArray *)absoluteIndexPathsForControllerIndexPaths:(NSArray *)controllerIndexPaths {
	NSMutableArray *absoluteIndexPaths = [NSMutableArray arrayWithCapacity:[controllerIndexPaths count]];
	for (NSIndexPath *controllerIndexPath in controllerIndexPaths) {
		[absoluteIndexPaths addObject:[self absoluteIndexPathForControllerIndexPath:controllerIndexPath]];
	}
	return absoluteIndexPaths;
}

- (NSIndexSet *)absoluteSectionIndexSetForControllerSectionIndexSet:(NSIndexSet *)controllerSectionIndexSet {
	NSMutableIndexSet *absoluteSectionIndexSet = [NSMutableIndexSet indexSet];
	for (NSUInteger controllerSection = [controllerSectionIndexSet firstIndex]; 
		  controllerSection != NSNotFound; 
		  controllerSection = [controllerSectionIndexSet indexGreaterThanIndex:controllerSection]) 
	{
		[absoluteSectionIndexSet addIndex:[self absoluteSectionForControllerSection:controllerSection]];
	}
	return absoluteSectionIndexSet;
}

#pragma mark Private methods

- (NSIndexPath *)expandedRelativeIndexPathForFlattenedAbsoluteIndexPath:(NSIndexPath *)absoluteIndexPath withBaseSection:(NSUInteger)baseSection andBaseRow:(NSUInteger)baseRow {
	NSAssert2 (absoluteIndexPath.section == baseSection, @"absoluteIndexPath.section (%d) != baseSection (%d)", absoluteIndexPath.section, baseSection);
	NSUInteger rowOffset = absoluteIndexPath.row - baseRow;
	NSUInteger section = 0;
	NSUInteger rowsObservedSoFar = 0;
	NSUInteger rowsObservedWithThisSection = 0;
	while (section < [controller numberOfSectionsInTableView:controller.tableView]) {
		rowsObservedWithThisSection += [controller tableView:controller.tableView numberOfRowsInSection:section];
		if (rowsObservedWithThisSection > rowOffset) return [NSIndexPath indexPathForRow:rowOffset - rowsObservedSoFar inSection:section];
		rowsObservedSoFar = rowsObservedWithThisSection;
		section += 1;
	}
	NSAssert3 (0, @"Couldn't find expandedRelativeIndexPathForFlattenedAbsoluteIndexPath:%@ withBaseSection: %d andBaseRow:%d", [absoluteIndexPath description], baseSection, baseRow);
	return nil;
}


@end
