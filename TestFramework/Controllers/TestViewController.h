//
//  untitled.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestOperationDelegate.h"


@interface TestViewController : UIViewController <TestOperationDelegate> {
   TestOperation *testOperation;
   IBOutlet UIProgressView *progressView;
   IBOutlet UILabel *testResultLabel;
   IBOutlet UILabel *testSuiteLabel;
   IBOutlet UILabel *testNameLabel;
   
   TestSuite *rootSuite;
   int passCount;
   int totalCount;
}

@property(retain) TestOperation *testOperation;
@property(retain) TestSuite *rootSuite;

- (IBAction) runTests: (id)source;
- (IBAction) stopTests: (id)source;

@end
