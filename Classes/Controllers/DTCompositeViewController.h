//
//  DTCompositeViewController.h
//
//  Created by Curtis Duhn on 12/23/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTViewController.h"

@interface DTCompositeViewController : DTViewController {
	NSMutableSet *subviewControllers;
}

@property (nonatomic, retain, readonly) NSMutableSet *subviewControllers;

// Call this in viewDidLoad or before to add view controllers for any subviews so that they will receive
// viewDid/WillAppear/Disappear messages.
- (void)addSubviewController:(id <DTActsAsChildViewController>)subviewController;

// Call this to remove the subviewController when you remove its view from its superview
- (void)removeSubviewController:(id <DTActsAsChildViewController>)subviewController;


@end
