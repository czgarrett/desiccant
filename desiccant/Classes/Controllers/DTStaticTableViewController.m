//
//  DTStaticTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTStaticTableViewController.h"
#import "DTTableViewRow.h"
#import "Zest.h"

@interface DTStaticTableViewController()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
- (NSMutableArray *)currentSection;
- (DTTableViewRow *)tableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath;
- (DTCustomTableViewCell *)prototypeCellForNibNamed:(NSString *)nibName;
@end

@implementation DTStaticTableViewController
@synthesize sections, sectionTitles, prototypeCells;

- (void)dealloc {
    self.sections = nil;
    self.sectionTitles = nil;
	self.prototypeCells = nil;
    
    [super dealloc];
}

#pragma mark DTTableViewController methods

- (void)viewDidLoad {
    self.sections = [NSMutableArray arrayWithCapacity:16];
    self.sectionTitles = [NSMutableArray arrayWithCapacity:16];
	self.prototypeCells = [NSMutableDictionary dictionaryWithCapacity:2];
	[super viewDidLoad];
}

//- (void)afterViewDidLoad:(UITableView *)theTableView {
//	[super afterViewDidLoad:theTableView];
//    self.sections = [NSMutableArray arrayWithCapacity:16];
//    self.sectionTitles = [NSMutableArray arrayWithCapacity:16];
//	self.prototypeCells = [NSMutableDictionary dictionaryWithCapacity:2];
//}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DTTableViewRow *row = [self tableView:tableView rowAtIndexPath:indexPath];
    if (row.detailViewController) {
		if (row.dataInjector) {
			NSAssert ([row.detailViewController respondsToSelector:row.dataInjector], 
					  @"Detail view controller doesn't respond to the selector provided as the data injector .");
			NSAssert (row.dataDictionary, @"Selector provided for data injector, but no data provided.");
			[row.detailViewController performSelector:row.dataInjector withObject:row.dataDictionary];
		}
        [[self navigationControllerToReceivePush] pushViewController:row.detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTTableViewRow *row = [self tableView:tableView rowAtIndexPath:indexPath];
	self.cell = row.cell;
	if (!cell) {
		self.cell = [self prototypeCellForNibNamed:row.nibName];
	}
	self.cell.width = self.tableView.cellWidth;
	if (row && row.dataDictionary) {
		[cell setData:row.dataDictionary];
	}
	return cell.bounds.size.height;
}

#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DTTableViewRow *row = [self tableView:tableView rowAtIndexPath:indexPath];
	if (row.cell) {
		return row.cell;
	}
	else {
		NSAssert (row.nibName, @"A row must have a nib name if it doesn't have a dedicated cell.");
		if (row.reuseIdentifier) {
			self.cell = (DTCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:row.reuseIdentifier];
			if (!cell) {
				[[NSBundle mainBundle] loadNibNamed:row.nibName owner:self options:nil];
			}
			[cell setData:row.dataDictionary];
		}
		else {
			[[NSBundle mainBundle] loadNibNamed:row.nibName owner:self options:nil];
			[cell setData:row.dataDictionary];
			row.cell = cell;
		}
		return cell;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < [sectionTitles count]) {
        return (NSString *)[sectionTitles objectAtIndex:section];
    }
    else {
        return nil;
    }
}

#pragma mark Public methods

- (void)startSection {
    [self startSectionWithTitle:nil];
}

- (void)startSectionWithTitle:(NSString *)title {
    [sections addObject:[NSMutableArray array]];
    if (title) {
        [sectionTitles addObject:title];
    }
    else {
        [sectionTitles addObject:@""];
    }
}

- (void)insertSectionAtIndex:(NSUInteger)index {
	[self insertSectionAtIndex:index withTitle:nil];
}

- (void)insertSectionAtIndex:(NSUInteger)index withTitle:(NSString *)title {
    [sections insertObject:[NSMutableArray array] atIndex:index];
    if (title) {
        [sectionTitles insertObject:title atIndex:index];
    }
    else {
        [sectionTitles insertObject:@"" atIndex:index];
    }
}

- (void)removeSectionWithIndex:(NSUInteger)index {
	[sections removeObjectAtIndex:index];
	[sectionTitles removeObjectAtIndex:index];
}

- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell {
	[self addRowWithDedicatedCell:theCell data:nil detailViewController:nil dataInjector:nil];
}

- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData {
	[self addRowWithDedicatedCell:theCell data:rowData detailViewController:nil dataInjector:nil];
}

- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController {
	[self addRowWithDedicatedCell:theCell data:rowData detailViewController:detailViewController dataInjector:nil];
}

- (void)addRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector {
	NSAssert (theCell.reuseIdentifier == nil, @"Dedicated cell must not have a reuse identifier");
    [[self currentSection] addObject:[DTTableViewRow rowWithCell:theCell data:rowData detailViewController:detailViewController dataInjector:dataInjector]];
}

- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithDedicatedCell:theCell data:nil detailViewController:nil dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData  atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithDedicatedCell:theCell data:rowData detailViewController:nil dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithDedicatedCell:theCell data:rowData detailViewController:detailViewController dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithDedicatedCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector atIndexPath:(NSIndexPath *)indexPath {
	NSAssert (theCell.reuseIdentifier == nil, @"Dedicated cell must not have a reuse identifier");
    [[sections mutableArrayAtIndex:indexPath.section] insertObject:[DTTableViewRow rowWithCell:theCell data:rowData detailViewController:detailViewController dataInjector:dataInjector] atIndex:indexPath.row];
}

- (void)addRowWithNibNamed:(NSString *)nibName {
	[self addRowWithNibNamed:nibName data:nil detailViewController:nil dataInjector:nil]; 
}

- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData {
	[self addRowWithNibNamed:nibName data:rowData detailViewController:nil dataInjector:nil]; 
}

- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController {
	[self addRowWithNibNamed:nibName data:rowData detailViewController:detailViewController dataInjector:nil]; 
}

- (void)addRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector {
	DTCustomTableViewCell *prototype = [self prototypeCellForNibNamed:nibName];
	[[self currentSection] addObject:[DTTableViewRow rowWithNibNamed:nibName data:rowData detailViewController:detailViewController dataInjector:dataInjector reuseIdentifier:prototype.reuseIdentifier]];
}

- (void)insertRowWithNibNamed:(NSString *)nibName atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithNibNamed:nibName data:nil detailViewController:nil dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithNibNamed:nibName data:rowData detailViewController:nil dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController atIndexPath:(NSIndexPath *)indexPath {
	[self insertRowWithNibNamed:nibName data:rowData detailViewController:detailViewController dataInjector:nil atIndexPath:indexPath];
}

- (void)insertRowWithNibNamed:(NSString *)nibName data:(NSDictionary *)rowData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector atIndexPath:(NSIndexPath *)indexPath {
	DTCustomTableViewCell *prototype = [self prototypeCellForNibNamed:nibName];
	[[sections mutableArrayAtIndex:indexPath.section] insertObject:[DTTableViewRow rowWithNibNamed:nibName data:rowData detailViewController:detailViewController dataInjector:dataInjector reuseIdentifier:prototype.reuseIdentifier] atIndex:indexPath.row];
}

- (void)addRowsWithNibNamed:(NSString *)nibName dataArray:(NSArray *)rowDataArray {
	[self addRowsWithNibNamed:nibName dataArray:rowDataArray detailViewController:nil dataInjector:nil];
}

- (void)addRowsWithNibNamed:(NSString *)nibName dataArray:(NSArray *)rowDataArray detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)dataInjector {
	DTCustomTableViewCell *prototype = [self prototypeCellForNibNamed:nibName];
	for (NSDictionary *rowData in rowDataArray) {
		[[self currentSection] addObject:[DTTableViewRow rowWithNibNamed:nibName data:rowData detailViewController:detailViewController dataInjector:dataInjector reuseIdentifier:prototype.reuseIdentifier]];
	}	
}

- (void)removeRowWithIndexPath:(NSIndexPath *)indexPath {
	NSAssert (indexPath.section < [sections count], @"Section index out of range");
	NSMutableArray *section = [sections mutableArrayAtIndex:indexPath.section];
	NSAssert (indexPath.row < [section count], @"Row index out of range");
	[section removeObjectAtIndex:indexPath.row];
}

- (id)cellWithNibNamed:(NSString *)nibName {
	[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	return cell;
}

- (NSDictionary *)dataDictionaryForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self tableView:nil rowAtIndexPath:indexPath] dataDictionary];
}

#pragma mark Private methods

- (DTTableViewRow *)tableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath {
    return (DTTableViewRow *)[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSMutableArray *)currentSection {
    if ([sections count] == 0) {
        [self startSectionWithTitle:@""];
    }
    return (NSMutableArray *)[sections lastObject];
}

- (DTCustomTableViewCell *)prototypeCellForNibNamed:(NSString *)nibName {
	DTCustomTableViewCell *prototype = [prototypeCells valueForKey:nibName];
	if (!prototype) {
		[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
		prototype = self.cell;
		NSAssert (prototype, @"Nib didn't set the cell property.");
//		prototype.width = self.tableView.width;
		[prototypeCells setObject:prototype forKey:nibName];
	}
	return prototype;
}

@end

