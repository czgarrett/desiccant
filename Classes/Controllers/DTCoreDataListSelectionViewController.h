
@class DTCoreDataListSelectionViewController;

@protocol DTCoreDataListSelectionViewControllerDelegate

- (void) selectionViewController: (DTCoreDataListSelectionViewController *) psvc didSelectObject: (NSManagedObject *) object;

@optional

- (void) selectionViewControllerDidCancel: (DTCoreDataListSelectionViewController *) lsvc;

@end

@interface DTCoreDataListSelectionViewController : DTCoreDataTableViewController <UISearchDisplayDelegate> {
   
   id <DTCoreDataListSelectionViewControllerDelegate> delegate;
   NSManagedObject *selectedObject;
   
   IBOutlet UIBarButtonItem *editButton;
   IBOutlet UIBarButtonItem *saveButton;

   BOOL editable;
   NSInteger tag;
   
   BOOL needsFiltering;
   BOOL currentlyFiltering;
   
   NSString *currentSearchText;
   NSInteger currentSearchScope;
}

@property (nonatomic, retain) NSString *currentSearchText;
@property (nonatomic, assign) NSInteger currentSearchScope;

@property (nonatomic, assign) id <DTCoreDataListSelectionViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObject *selectedObject;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL editable;


- (void) filterContentForSearchText: (NSString *) searchText scope: (NSInteger) scopeIndex;
- (NSPredicate *) predicateForSearchText: (NSString *)searchText scope: (NSInteger) scopeIndex;

- (IBAction) editButtonPressed: (id) button;
- (IBAction) saveButtonPressed: (id) button;

- (void) updateFooterView;

@end
