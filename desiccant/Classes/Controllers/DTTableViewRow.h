//
//  DTTableViewRow.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTCustomTableViewCell;

@interface DTTableViewRow : NSObject {
    DTCustomTableViewCell *cell;
    UIViewController *detailViewController;
	NSDictionary *dataDictionary;
	SEL dataInjector;
	NSString *reuseIdentifier;
	NSString *nibName;
}

@property (nonatomic, retain) DTCustomTableViewCell *cell;
@property (nonatomic, retain) UIViewController *detailViewController;
@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (nonatomic) SEL dataInjector;
@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic, retain) NSString *nibName;
@property (nonatomic) CGRect originalFrame;

- (id)initWithCell:(DTCustomTableViewCell *)theCell nibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier;
- (id)initWithCell:(DTCustomTableViewCell *)theCell data:(NSDictionary *)theData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector;
- (id)initWithNibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier;
+ (id)rowWithCell:(DTCustomTableViewCell *)cell data:(NSDictionary *)theData detailViewController:(UIViewController *)detailViewController dataInjector:(SEL)theDataInjector;
+ (id)rowWithNibNamed:(NSString *)theNibName data:(NSDictionary *)theRowData detailViewController:(UIViewController *)theDetailViewController dataInjector:(SEL)theDataInjector reuseIdentifier:(NSString *)theReuseIdentifier;

@end
