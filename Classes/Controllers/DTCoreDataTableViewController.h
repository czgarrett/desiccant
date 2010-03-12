#import <CoreData/CoreData.h>
#import "DTCustomTableViewController.h"

#define DEFAULT_FETCH_LIMIT 100

@interface DTCoreDataTableViewController : DTCustomTableViewController <NSFetchedResultsControllerDelegate> {

   NSFetchedResultsController *fetchedResultsController;
   NSManagedObjectContext *managedObjectContext;
   NSPredicate *defaultPredicate;
   NSString *entityName;
   NSString *sortAttribute;
   BOOL ascending;
   NSInteger fetchLimit;
   BOOL firstFetchComplete;
   
   // Replaces the table footer when the number of results is equal to the fetch limit.
   IBOutlet UIView *tooManyResultsFooterView;
   IBOutlet UISearchBar *searchBar;
   BOOL searchable;
   
   // There is some unexpected behavior when using search bars and 
   // scope.  The search text is cleared when you select a scope button
   // and close the search.  The result is that the items shown are
   // limited by both scope and search term, but the search term is
   // no longer seen.  So, the user is confused because they think
   // the list isn't being filtered, when in fact it is.
   // To work around this, I use willEndSearch and didEndSearch
   // delegate methods to store the search text and reset it.
   // So, don't use this for anything else, as the current state
   // will be unpredictable.
   NSString *tempSearchText;

}

@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSString *sortAttribute;
@property (nonatomic, retain) NSPredicate *defaultPredicate;
@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, assign) BOOL searchable;
@property (nonatomic, assign) NSInteger fetchLimit;
@property (nonatomic, readonly) UISearchBar *searchBar;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) performFetch;

- (id) initWithEntityName: (NSString *) myEntityName sortAttribute: (NSString *) mySortAttribute;

@end
