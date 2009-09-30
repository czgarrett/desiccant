#ifdef __IPHONE_3_0
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DTCoreDataApplicationDelegate : NSObject <UIApplicationDelegate> {
   
   NSManagedObjectModel *managedObjectModel;
   NSManagedObjectContext *managedObjectContext;
   NSPersistentStoreCoordinator *persistentStoreCoordinator;
   
}

+ (DTCoreDataApplicationDelegate *) sharedDelegate;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end
#endif