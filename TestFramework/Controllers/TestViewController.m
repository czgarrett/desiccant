//
//  untitled.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 6/12/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "TestViewController.h"
#import "TestOperation.h"
#import "TestAppDelegate.h"


@implementation TestViewController

@synthesize testOperation;
@synthesize rootSuite;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
	return self;
}

- (void)dealloc
{
   self.testOperation = nil;
   self.rootSuite = nil;
   [super dealloc];
}

- (void)runTests: (id)source
{
   progressView.hidden = NO;
   testNameLabel.textColor = [UIColor whiteColor];
   testSuiteLabel.textColor = [UIColor whiteColor];

   self.testOperation = [[TestOperation alloc] initWithRootTest: rootSuite delegate: self];
   [testOperation release];
   TestAppDelegate *delegate = (TestAppDelegate *) [[UIApplication sharedApplication] delegate];
   [[delegate operationQueue] addOperation: testOperation];   
}

- (void)viewWillAppear:(BOOL)animated
{
   totalCount = [rootSuite count];
   passCount = 0;
   testSuiteLabel.text = [rootSuite name];
   testNameLabel.text = @"";
   progressView.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)testSuiteStarted:(TestSuite *)test
{
   testSuiteLabel.text = [test name];
}
- (void)testStarted:(AbstractTest *)test
{
   testNameLabel.text = [test name];  
}
- (void)testPassed
{
   passCount++;
   progressView.progress = (float)passCount / (float)totalCount;
}
- (void)testFailed:(AbstractTest *)test
{
   testNameLabel.textColor = [UIColor redColor];
   testSuiteLabel.textColor = [UIColor redColor];
   testResultLabel.backgroundColor = [UIColor blackColor];
   testResultLabel.textColor = [UIColor whiteColor];
   testResultLabel.textAlignment = UITextAlignmentLeft;
   testResultLabel.text = testOperation.failureMessage;
}
- (void)allTestsPassed
{
   testResultLabel.backgroundColor = [UIColor blackColor];
   testResultLabel.textColor = [UIColor greenColor];
   testResultLabel.textAlignment = UITextAlignmentCenter;
   progressView.progress = 1.0;
   NSString *template = @"%d tests passed!";
   if (totalCount == 1) {
      template = @"%d test passed!";
   }
   testResultLabel.text = [NSString stringWithFormat: template, totalCount];
}

- (void)stopTests: (id)source {
   if (testOperation) {
      [testOperation cancel];
   }
}


@end
