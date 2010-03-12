//
//  DTToggleViewController.h
//  iRevealMaui
//
//  Created by Ilan Volow on 10/27/09.
//  Copyright 2009 ZWorkBench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTActsAsChildViewController.h"
#import "DTViewController.h"

@class DTToggleViewController;

/*!
    @class       DTToggleViewController 
    @superclass  UIViewController {
    @abstract    The DTToggleViewController implements a view controller that allows switching between a front and back view.
*/
@interface DTToggleViewController : DTViewController {
	UIViewController  <DTActsAsChildViewController> *dtFrontViewController;
	UIViewController  <DTActsAsChildViewController> *dtBackViewController;
	UIImage *frontToggleButtonImage;
	UIImage *backToggleButtonImage;
	BOOL backIsShowing;
	UIBarButtonItem *toggleBarButtonItem;
	BOOL dtHideToggleButton;
	BOOL backIsLoaded;
}

@property (nonatomic, retain) IBOutlet UIViewController <DTActsAsChildViewController> *frontViewController;
@property (nonatomic, retain) IBOutlet UIViewController <DTActsAsChildViewController> *backViewController;
@property (nonatomic, retain, readonly) UIViewController <DTActsAsChildViewController> *currentViewController;
@property (nonatomic, retain, readonly) UIViewController <DTActsAsChildViewController> *hiddenViewController;
@property (retain, nonatomic) IBOutlet UIImage *frontToggleButtonImage;
@property (nonatomic, retain) IBOutlet UIImage *backToggleButtonImage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *toggleBarButtonItem;
@property (nonatomic) BOOL hideToggleButton;

- (id)initWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController 
			   backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController 
		   frontToggleButtonImage:(UIImage *)theFrontToggleButtonImage
			backToggleButtonImage:(UIImage *)theBackToggleButtonImage;
+ (DTToggleViewController *)controllerWithFrontViewController:(UIViewController <DTActsAsChildViewController>*)aFrontController 
										   backViewController:(UIViewController <DTActsAsChildViewController>*)aBackController 
									   frontToggleButtonImage:(UIImage *)theFrontToggleButtonImage
										backToggleButtonImage:(UIImage *)theBackToggleButtonImage;
- (void)toggle;
- (IBAction)toggleButtonClicked:(id)sender;

@end
