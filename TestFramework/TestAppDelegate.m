//
//  TestAppDelegate.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestAppDelegate.h"
#import "SQLiteConnectionAdapter.h"
#import "TestViewController.h"

@implementation TestAppDelegate

@synthesize window;
@synthesize contentView;
@synthesize testViewController;

- (void)dealloc
{
   [testViewController release];
   [operationQueue release];
   [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
   NSLog(@"Starting app");
   operationQueue = [[NSOperationQueue alloc] init];
   [[self window] addSubview: [testViewController view]];
   [[self window] makeKeyAndVisible];
}      

-(NSOperationQueue *) operationQueue
{
   return operationQueue;
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
