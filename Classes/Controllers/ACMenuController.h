
#import "FileMenuItem.h"

@interface ACMenuController : UITableViewController {
   NSMutableArray *items;
   UITableView *tableView;
   FileMenuItem *fileMenuItem;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) FileMenuItem *fileMenuItem;


- (id) initWithFileMenuItem: (FileMenuItem *) fileMenuItem;

/*
- (NSDictionary *) sectionAtIndex: (NSInteger) index;
- (NSString *) sectionName: (NSInteger) sectionIndex;
- (NSMutableArray *) itemsInSection: (NSInteger)sectionIndex;
- (NSDictionary *) itemForIndexPath: (NSIndexPath *)path;
*/


@end
