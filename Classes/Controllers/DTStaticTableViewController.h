//
//  DTStaticTableViewController.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 6/28/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTableViewController.h"

@interface DTStaticTableViewController : DTTableViewController {
    NSMutableArray *sections;
    NSMutableArray *sectionTitles;
}

@property (nonatomic, retain, readonly) NSMutableArray *sections;
@property (nonatomic, retain, readonly) NSMutableArray *sectionTitles;

- (void)startSection;
- (void)startSectionWithTitle:(NSString *)title;
- (void)addRowWithNibNamed:(NSString *)nibName data:(NSMutableDictionary *)rowData;
- (void)addRowWithNibNamed:(NSString *)nibName data:(NSMutableDictionary *)rowData detailViewController:(UIViewController *)detailViewController;
    
@end
