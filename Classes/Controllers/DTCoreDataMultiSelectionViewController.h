@class DTCoreDataMultiSelectionViewController;

@protocol DTCoreDataMultiSelectionViewControllerDelegate

- (void) multiSelectionViewController: (DTCoreDataMultiSelectionViewController *) psvc didSelectObjects: (NSSet *) objects;

@end

@interface DTCoreDataMultiSelectionViewController : DTCoreDataTableViewController <UISearchDisplayDelegate> {
   
   id <DTCoreDataMultiSelectionViewControllerDelegate> delegate;
   NSMutableSet *selectedObjects;
   
   IBOutlet UIBarButtonItem *nextButton;
   IBOutlet UIBarButtonItem *cancelButton;
}

@property (nonatomic, assign) id <DTCoreDataMultiSelectionViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableSet *selectedObjects;


- (void) filterContentForSearchText: (NSString *) searchText scope: (NSInteger) scopeIndex;
- (NSPredicate *) predicateForSearchText: (NSString *)searchText scope: (NSInteger) scopeIndex;

- (IBAction) nextButtonPressed: (id) button;
- (IBAction) cancelButtonPressed: (id) button;
- (IBAction) selectAllButtonPressed: (id) button;
- (IBAction) selectNoneButtonPressed: (id) button;


@end
