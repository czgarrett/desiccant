//
//  ACNavigationAppDelegate.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 9/20/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "ACNavigationAppDelegate.h"
#import "SQLiteConnectionAdapter.h"
#import "desiccant.h"

@implementation ACNavigationAppDelegate 

@synthesize window;
@synthesize startViewController;
@synthesize navigationController;
@synthesize operationQueue;
@synthesize initialControllerClass;

- (id) initWithInitialControllerClass: (Class) myControllerClass {
   if (self == [self init]) {
      self.initialControllerClass = myControllerClass;
   }
   return self;
}

- (id) init {
   if (self == [super init]) {
      NSOperationQueue *oq = [[NSOperationQueue alloc] init];
      self.operationQueue = oq;
      [oq release];            
   }
   return self;
}

+ (NSOperationQueue *)sharedOperationQueue
{
	UIApplication *myapp = [UIApplication sharedApplication];
	ACNavigationAppDelegate *delegate = (ACNavigationAppDelegate *) myapp.delegate;
	return delegate.operationQueue;
}

+ (ACNavigationAppDelegate *) sharedDelegate
{
   return (ACNavigationAppDelegate *) [[UIApplication sharedApplication] delegate];
}

+ (void) addOperationToSharedQueue: (NSOperation *) operation
{
   [[self sharedOperationQueue] addOperation: operation];
}

- (void)createStartViewController {
   self.startViewController = [[[self.initialControllerClass class] alloc] autorelease];   
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
   unless(self.startViewController) {
      [self createStartViewController];      
   }
	self.navigationController = [[UINavigationController alloc] initWithRootViewController: self.startViewController];
	[self.navigationController release]; // retained when property is set
	navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
   
	[[navigationController view] setBackgroundColor: [UIColor blackColor]];
   [window addSubview: [navigationController view]];
   [window makeKeyAndVisible];
}


- (void)dealloc {
	self.operationQueue = nil;
   [startViewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
   [SQLiteConnectionAdapter releaseDefaultInstance];
}

@end
