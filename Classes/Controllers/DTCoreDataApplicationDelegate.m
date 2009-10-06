//
//  DTCoreDataApplicationDelegate.m
//  ProLog
//
//  Created by Christopher Garrett on 9/3/09.
//  Copyright 2009 ZWorkbench, Inc.. All rights reserved.
//

#ifdef __IPHONE_3_0
#import "DTCoreDataApplicationDelegate.h"


@implementation DTCoreDataApplicationDelegate

@synthesize splashView, window, navigationController;

+ (DTCoreDataApplicationDelegate *) sharedDelegate {
   return (DTCoreDataApplicationDelegate *) [[UIApplication sharedApplication] delegate];
}

#pragma mark Lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
   [self setUpSplash];
}

- (void) dealloc {
   self.splashView = nil;
   self.window = nil;
   self.navigationController = nil;
   [managedObjectContext release];
   [managedObjectModel release];
   [persistentStoreCoordinator release];
   [super dealloc];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
   if (managedObjectContext != nil) {
      return managedObjectContext;
   }
	
   NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
   if (coordinator != nil) {
      managedObjectContext = [[NSManagedObjectContext alloc] init];
      [managedObjectContext setPersistentStoreCoordinator: coordinator];
   }
   return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
   if (managedObjectModel != nil) {
      return managedObjectModel;
   }
   managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
   return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
   if (persistentStoreCoordinator != nil) {
      return persistentStoreCoordinator;
   }
	
   NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"app.sqlite"]];
	
	NSError *error;
   persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
   if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
      NSLog(@"Persistent store creation error: %@", error);
   }    
	
   return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
   return basePath;
}

#pragma mark Splash screen

- (void) setUpSplash {
   UIImage *splashImage = [UIImage imageNamed: @"Default.png"];
   if (splashImage) {
      self.splashView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
      UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
      UIImageView *logo = [[UIImageView alloc] initWithImage: splashImage];
      [logoView addSubview:logo];
      [self.splashView addSubview:logoView];
      [self.navigationController.view addSubview:self.splashView];	
      [self.navigationController.view bringSubviewToFront:self.splashView];
      [logoView release];
      [logo release];
      [NSTimer scheduledTimerWithTimeInterval: 0.5 
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



@end

#endif