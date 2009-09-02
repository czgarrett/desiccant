//
//  TestAppDelegate.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestAppDelegate : NSObject {
   IBOutlet UIWindow *window;
   IBOutlet UIView *contentView;
   IBOutlet UIViewController *testViewController;
   NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIViewController *testViewController;

-(NSOperationQueue *) operationQueue;

@end
