
#import "ACMenuController.h"
#import "ACDocumentViewController.h"

@implementation ACMenuController

@synthesize items, tableView, fileMenuItem;


- (id) initWithFileMenuItem: (FileMenuItem *) myFileMenuItem {
   if (self = [self initWithStyle: UITableViewStylePlain]) {
      self.fileMenuItem = myFileMenuItem;
      self.items = [NSMutableArray array];
      NSFileManager *fileMgr = [NSFileManager defaultManager];
      NSError *error = nil;
      NSEnumerator *dirEnum = [[fileMgr contentsOfDirectoryAtPath:self.fileMenuItem.path error:&error] objectEnumerator];
      NSString *file;
      while (file = [dirEnum nextObject]) {
         FileMenuItem *menuItem = [[FileMenuItem alloc] initWithPath: [self.fileMenuItem.path stringByAppendingPathComponent: file]];
         if (menuItem.controllerClass) {
            [self.items addObject: menuItem];            
         }
         [menuItem release];
      }
      self.tabBarItem = [UITabBarItem itemNamed: self.fileMenuItem.title];
      self.title = self.fileMenuItem.title;
   }
   return self;
}



- (void) loadView {
   [super loadView];
   UIView *newView = [[[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 460.0)] autorelease];
   [newView addSubview: self.view];
   self.tableView = (UITableView *) self.view;
   self.tableView.frame = CGRectMake(0.0, 0.0, 320.0, 460.0);
   self.view = newView;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   FileMenuItem *cellItem = [self.items objectAtIndex: indexPath.row];
   UITableViewCellStyle style;
   NSString *cellIdentifier;
   if (cellItem.description) {
      style = UITableViewCellStyleSubtitle;
      cellIdentifier = @"ACMenuControllerCellSubtitle";
   } else {
      style = UITableViewCellStyleDefault;
      cellIdentifier = @"ACMenuControllerCellDefault";
   }
   
   UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
   if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle: style reuseIdentifier: cellIdentifier] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   }
   cell.textLabel.text = cellItem.title;      
   cell.detailTextLabel.text = cellItem.description;
   return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   FileMenuItem *selectedItem = [self.items objectAtIndex: indexPath.row];
   UIViewController *nextViewController = [[[selectedItem.controllerClass class] alloc] initWithFileMenuItem: selectedItem];
   [self.navigationController pushViewController: nextViewController animated: YES];
   [nextViewController release];
}


#pragma mark Memory

- (void)dealloc {
   self.items = nil;
   self.tableView = nil;
   self.fileMenuItem = nil;
   [super dealloc];
}

@end

