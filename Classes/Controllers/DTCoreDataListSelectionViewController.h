
@class DTCoreDataListSelectionViewController;

@protocol DTCoreDataListSelectionViewControllerDelegate

- (void) selectionViewController: (DTCoreDataListSelectionViewController *) psvc didSelectObject: (NSManagedObject *) object;

@optional

- (void) selectionViewControllerDidCancel: (DTCoreDataListSelectionViewController *) lsvc;

@end

@interface DTCoreDataListSelectionViewController : DTCoreDataTableViewController <UISearchDisplayDelegate> {
   
   id <DTCoreDataListSelectionViewControllerDelegate> delegate;
   NSManagedObject *selectedObject;
   IBOutlet UISearchBar *searchBar;
}

@property (nonatomic, assign) id <DTCoreDataListSelectionViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObject *selectedObject;
@property (nonatomic, readonly) UISearchBar *searchBar;

- (void) filterContentForSearchText: (NSString *) searchText scope: (NSInteger) scopeIndex;
- (NSPredicate *) predicateForSearchText: (NSString *)searchText scope: (NSInteger) scopeIndex;

@end
