

#import "desiccant_controllers.h"


@interface DTCoreDataTableViewController : DTCustomTableViewController <NSFetchedResultsControllerDelegate> {

   NSFetchedResultsController *fetchedResultsController;
   NSManagedObjectContext *managedObjectContext;
   NSString *entityName;
   NSString *sortAttribute;
   BOOL ascending;   
}

@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSString *sortAttribute;
@property (nonatomic, assign) BOOL ascending;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (id) initWithEntityName: (NSString *) myEntityName sortAttribute: (NSString *) mySortAttribute;

@end
