
#import <UIKit/UIKit.h>
#import "Zest.h"

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
@property (nonatomic, assign) BOOL hasSeenContinueButton;

+ (NSOperationQueue *) sharedOperationQueue;
+ (void) addOperationToSharedQueue: (NSOperation *) operation;
+ (ACTabbedAppDelegate *) sharedDelegate;

- (void) createDocumentsDirectory;
- (NSString *) pathForWritableFile: (NSString *)fileName;
- (void) setUpSplash;
- (void) hideSplash;
- (void) setUpTabBarController;
// Subclasses can override this to return an alternate UITabBarController implementation.  Returns a
// UITabBarControllerRotating by default.
- (UITabBarController *)createTabBarController;
- (void) createTabs;
// Subclasses can override this to provide a button to click the first time they see the app
- (UIButton *) firstTimeContinueButton;

@end