//
//  DTModalNavigationController.m
//  desiccant
//
//  Created by Curtis Duhn on 5/6/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.
//

#import "DTModalNavigationController.h"
#import "UINavigationController+Zest.h"

@interface DTModalNavigationController()
@property (nonatomic) BOOL managesLeftBarButtonItemForRoot;
@end

@implementation DTModalNavigationController
@synthesize managesLeftBarButtonItemForRoot;

#pragma mark Memory management

- (void)dealloc {
    if (self.managesLeftBarButtonItemForRoot) {
        ((UIViewController *)[self.viewControllers objectAtIndex:0]).navigationItem.leftBarButtonItem = nil;
    }
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    if ((self = [super initWithRootViewController:rootViewController])) {
        self.modalPresentationStyle = rootViewController.modalPresentationStyle;
    }
    return self;
}

+ (id)controllerWithRootViewController:(UIViewController *)rootViewController {
    return [[[self alloc] initWithRootViewController:rootViewController] autorelease];
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.rootViewController.navigationItem.leftBarButtonItem) {
        self.managesLeftBarButtonItemForRoot = YES;
        self.rootViewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(closeButtonWasClicked:)] autorelease];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark Private

- (void)closeButtonWasClicked:(id)sender {
    if (self.modalPresenter) {
        [self.modalPresenter dismissModalViewControllerAnimated:YES];
    }
    else {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

@end
