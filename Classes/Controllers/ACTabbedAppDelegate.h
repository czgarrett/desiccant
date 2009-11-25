
#import <UIKit/UIKit.h>

@interface ACTabbedAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate> {
   IBOutlet UIWindow *window;
   IBOutlet UITabBarController *tabBarController;
   NSOperationQueue *operationQueue;
	UIView							*splashView;
}

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UIView *splashView;

+ (NSOperationQueue *) sharedOperationQueue;
+ (void) addOperationToSharedQueue: (NSOperation *) operation;
+ (ACTabbedAppDelegate *) sharedDelegate;

- (void) createDocumentsDirectory;
- (NSString *) pathForWritableFile: (NSString *)fileName;
- (void) setUpSplash;
- (void) hideSplash;
- (void) setUpTabBarController;
- (void) createTabs;
@end