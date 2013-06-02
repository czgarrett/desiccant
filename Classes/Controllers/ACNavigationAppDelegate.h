//
//  ACNavigationAppDelegate.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 9/20/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACNavigationAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
   IBOutlet UIViewController *startViewController;
   IBOutlet UINavigationController *navigationController;
	NSOperationQueue *operationQueue;
   Class initialControllerClass;
}

//@property (nonatomic) Class initialControllerClass;
//@property (nonatomic, retain) NSOperationQueue *operationQueue;
//@property (nonatomic, retain) UIWindow *window;
//@property (nonatomic, retain) UIViewController *startViewController;
//@property (nonatomic, retain) UINavigationController *navigationController;
//
//- (id) initWithInitialControllerClass: (Class) myControllerClass;
//- (void)createStartViewController;
//+ (NSOperationQueue *) sharedOperationQueue;
//+ (ACNavigationAppDelegate *) sharedDelegate;
//+ (void) addOperationToSharedQueue: (NSOperation *) operation;
//
@end