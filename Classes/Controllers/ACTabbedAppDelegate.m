//
//#import "ACTabbedAppDelegate.h"
//#import "SQLiteConnectionAdapter.h"
//#import "UITabBarControllerRotating.h"
//#import "Zest.h"
//
//@implementation ACTabbedAppDelegate 
//
//@synthesize window, tabBarController, operationQueue, splashView;
//
//- (id) init {
//   if (self = [super init]) {
//      NSOperationQueue *oq = [[NSOperationQueue alloc] init];
//      self.operationQueue = oq;
//      [oq release];      
//      [self createDocumentsDirectory];
//   }
//   return self;
//}
//
//+ (NSOperationQueue *)sharedOperationQueue
//{
//	UIApplication *myapp = [UIApplication sharedApplication];
//	ACTabbedAppDelegate *delegate = (ACTabbedAppDelegate *) myapp.delegate;
//	return delegate.operationQueue;
//}
//
//+ (ACTabbedAppDelegate *) sharedDelegate
//{
//   return (ACTabbedAppDelegate *) [[UIApplication sharedApplication] delegate];
//}
//
//+ (void) addOperationToSharedQueue: (NSOperation *) operation
//{
//   [[self sharedOperationQueue] addOperation: operation];
//}
//
//- (BOOL) hasSeenContinueButton {
//   CFNumberRef hasLaunched = (CFNumberRef)CFPreferencesCopyAppValue(CFSTR("hasLaunched"), kCFPreferencesCurrentApplication);
//   BOOL result = NO;
//   if (hasLaunched != nil) {
//      result = [(NSNumber *)hasLaunched boolValue];
//      CFRelease(hasLaunched);
//   }
//   return result;
//}
//
//- (void) setHasSeenContinueButton: (BOOL) hasLaunched {
//   CFPreferencesSetAppValue(CFSTR("hasLaunched"), (CFNumberRef)[NSNumber numberWithBool: hasLaunched], kCFPreferencesCurrentApplication);
//   CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
//}
//
//
//- (void)applicationDidFinishLaunching:(UIApplication *)application {	
//   [self setUpTabBarController];
//   [window addSubview: tabBarController.view];
//   [window makeKeyAndVisible]; 
//   [self setUpSplash];     
//}
//
//- (void) setUpTabBarController {
//   tabBarController = [[self createTabBarController] retain];
//   tabBarController.view.backgroundColor = [UIColor blackColor];
//   tabBarController.delegate = self;
//   [self createTabs];
//}
//
//- (UITabBarController *)createTabBarController {
//	return [[[UITabBarControllerRotating alloc] init] autorelease];
//}
//
//- (void) createTabs {
//   // Stub method does nothing
//}
//
//- (void) setUpSplash {
//   UIImage *splashImage = [UIImage imageNamed: @"splash.png"];
//   unless (splashImage) {
//      splashImage = [UIImage imageNamed: @"Default.png"];
//   }
//   if (splashImage) {
//      tabBarController.view.alpha = 0.0;
//      self.splashView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
//      UIImageView *logo = [[UIImageView alloc] initWithImage: splashImage];
//      [self.splashView addSubview:logo];
//      [logo release];
//      UIButton *okButton = [self firstTimeContinueButton];
//      if (!self.hasSeenContinueButton && okButton) {
//         [self.splashView addSubview: okButton];
//      } else {
//         [NSTimer scheduledTimerWithTimeInterval: 0.5 
//                                          target:self 
//                                        selector:@selector(hideSplash) 
//                                        userInfo:nil 
//                                         repeats:NO];		               
//      }
//      [window addSubview:self.splashView];	
//      [window bringSubviewToFront:self.splashView];
//   }   
//}
//
//- (void) hideSplash {
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
//	self.splashView.alpha = 0;
//   self.tabBarController.view.alpha = 1.0;
//	[UIView commitAnimations];			
//   self.hasSeenContinueButton = YES;
//}
//
//
//- (void) createDocumentsDirectory {
//   NSFileManager *fileManager = [NSFileManager defaultManager];
//   NSError *error;
//   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//   NSString *documentsDirectory = [paths objectAtIndex:0];
//   if (![fileManager fileExistsAtPath: documentsDirectory]) {
//      [fileManager createDirectoryAtPath: documentsDirectory withIntermediateDirectories: YES attributes: nil error: &error];
//   }
//}
//
//- (NSString *) pathForWritableFile: (NSString *)fileName {
//   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//   NSString *documentsDirectory = [paths objectAtIndex:0];
//   return [documentsDirectory stringByAppendingPathComponent: fileName];
//}
//
//
//
//- (void)dealloc {
//	self.operationQueue = nil;
//   self.tabBarController = nil;
//	self.window = nil;
//   self.splashView = nil;
//	[super dealloc];
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//   [SQLiteConnectionAdapter releaseDefaultInstance];
//}
//
//// Subclasses can override this to provide a button to click the first time they see the app
//- (UIButton *) firstTimeContinueButton {
//   return nil;
//}
//
//
//#pragma mark UITabBarDelegate methods
//
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//   
//}
//
//- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
//   
//}
//
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//   
//}
//
//@end
