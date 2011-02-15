//
//  UIScrollView+Zest.h
//  Ziphany
//
//  Created by Curtis Duhn on 8/26/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView(Zest) 

// If returns the index of the page that currently fills most or all of the view
@property (nonatomic, assign, readonly) NSInteger currentHorizontalPage;

// If returns the index of the page that currently fills most or all of the view
@property (nonatomic, assign, readonly) NSInteger currentVerticalPage;

@end
