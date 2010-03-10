//
//  DTStaticTableViewController.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTStaticTableViewController.h"
#import "DTTableViewRow.h"

@interface DTStaticTableViewController()
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
- (NSMutableArray *)currentSection;
- (DTTableViewRow *)tableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation DTStaticTableViewController
@synthesize sections, sectionTitles;

- (void)dealloc {
    self.sections = nil;
    self.sectionTitles = nil;
    
    [super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sections = [NSMutableArray arrayWithCapacity:16];
    self.sectionTitles = [NSMutableArray arrayWithCapacity:16];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSAssert([self.sections count] > 0, @"No sections found for static table.  Make sure you're calling [super viewDidLoad] before adding rows in viewDidLoad.");
    return [self.sections count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.sections objectAtIndex:section] count];
}


- (DTTableViewRow *)tableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath {
    return (DTTableViewRow *)[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView rowAtIndexPath:indexPath].cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView rowAtIndexPath:indexPath].detailViewController) {
        [[self navigationControllerToReceivePush] pushViewController:[self tableView:tableView rowAtIndexPath:indexPath].detailViewController animated:YES];
    }
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section < [sectionTitles count]) {
        return (NSString *)[sectionTitles objectAtIndex:section];
    }
    else {
        return nil;
    }
}

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

- (void)addRowWithNibNamed:(NSString *)nibName data:(NSMutableDictionary *)rowData {
    [self addRowWithNibNamed:nibName data:rowData detailViewController:nil];
}

- (void)addRowWithNibNamed:(NSString *)nibName data:(NSMutableDictionary *)rowData detailViewController:(UIViewController *)detailViewController {
    [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    [tempCell setData:rowData];
    [[self currentSection] addObject:[DTTableViewRow rowWithCell:tempCell detailViewController:detailViewController]];
}

- (NSMutableArray *)currentSection {
    if ([sections count] == 0) {
        [self startSectionWithTitle:@""];
    }
    return (NSMutableArray *)[sections lastObject];
}

@end

