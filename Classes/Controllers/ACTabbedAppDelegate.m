//
//  ACNavigationAppDelegate.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 9/20/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "ACTabbedAppDelegate.h"
#import "SQLiteConnectionAdapter.h"

@implementation ACTabbedAppDelegate 

@synthesize window, tabBarController, operationQueue, splashView;

- (id) init {
   if (self == [super init]) {
      NSOperationQueue *oq = [[NSOperationQueue alloc] init];
      self.operationQueue = oq;
      [oq release];      
      [self createDocumentsDirectory];
   }
   return self;
}

+ (NSOperationQueue *)sharedOperationQueue
{
	UIApplication *myapp = [UIApplication sharedApplication];
	ACTabbedAppDelegate *delegate = (ACTabbedAppDelegate *) myapp.delegate;
	return delegate.operationQueue;
}

+ (ACTabbedAppDelegate *) sharedDelegate
{
   return (ACTabbedAppDelegate *) [[UIApplication sharedApplication] delegate];
}

+ (void) addOperationToSharedQueue: (NSOperation *) operation
{
   [[self sharedOperationQueue] addOperation: operation];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
   
   [self setUpTabBarController];
   [window addSubview: tabBarController.view];
   [window makeKeyAndVisible]; 
   [self setUpSplash];  
}

- (void) setUpTabBarController {
   tabBarController = [[UITabBarController alloc] initWithNibName: nil bundle: nil];
   tabBarController.view.backgroundColor = [UIColor blackColor];
   tabBarController.delegate = self;
}

- (void) setUpSplash {
   UIImage *splashImage = [UIImage imageNamed: @"splash.png"];
   if (splashImage) {
      self.splashView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
      UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
      UIImageView *logo = [[UIImageView alloc] initWithImage: splashImage];
      [logoView addSubview:logo];
      [self.splashView addSubview:logoView];
      [window addSubview:self.splashView];	
      [window bringSubviewToFront:self.splashView];
      [logoView release];
      [logo release];
      [NSTimer scheduledTimerWithTimeInterval:2.5 
                                       target:self 
                                     selector:@selector(hideSplash) 
                                     userInfo:nil 
                                      repeats:NO];		      
   }   
}

- (void) hideSplash {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	self.splashView.alpha = 0;
	[UIView commitAnimations];			
}


- (void) createDocumentsDirectory {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSError *error;
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   if (![fileManager fileExistsAtPath: documentsDirectory]) {
      [fileManager createDirectoryAtPath: documentsDirectory withIntermediateDirectories: YES attributes: nil error: &error];
   }
}

- (NSString *) pathForWritableFile: (NSString *)fileName {
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   return [documentsDirectory stringByAppendingPathComponent: fileName];
}



- (void)dealloc {
	self.operationQueue = nil;
   self.tabBarController = nil;
	self.window = nil;
   self.splashView = nil;
	[super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
   [SQLiteConnectionAdapter releaseDefaultInstance];
}

#pragma mark UITabBarDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
   
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
   
}

@end