#ifdef __IPHONE_3_0
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DTCoreDataApplicationDelegate : NSObject <UIApplicationDelegate> {
   
   NSManagedObjectModel *managedObjectModel;
   NSManagedObjectContext *managedObjectContext;
   NSPersistentStoreCoordinator *persistentStoreCoordinator;
   
   UIView *splashView;
   UIWindow *window;
   UINavigationController *navigationController;
}

+ (DTCoreDataApplicationDelegate *) sharedDelegate;

- (void) setUpSplash;
- (void) hideSplash;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIView *splashView;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end
#endif