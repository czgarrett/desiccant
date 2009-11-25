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

- (void)afterTableViewDidLoad:(UITableView *)theTableView {
	[super afterTableViewDidLoad:theTableView];
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
    UITableViewCell *theCell = [self tableView:tableView rowAtIndexPath:indexPath].cell;
	return theCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].bounds.size.height;
//    return ((UITableViewCell *)[(NSArray *)[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).bounds.size.height;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    NSAssert (cell.reuseIdentifier == nil, @"Your static cell has a reuse identifier defined in IB.  You should clear the Identifier field for maximum performance.");
    [cell setData:rowData];
    [[self currentSection] addObject:[DTTableViewRow rowWithCell:cell detailViewController:detailViewController]];
}

- (NSMutableArray *)currentSection {
    if ([sections count] == 0) {
        [self startSectionWithTitle:@""];
    }
    return (NSMutableArray *)[sections lastObject];
}

@end

