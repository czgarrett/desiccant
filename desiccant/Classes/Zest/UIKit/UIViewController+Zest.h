//
//  UIViewController+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/22/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Zest.h"

typedef enum {
   UILabelUsageHeading = 0,
   UILabelUsageSubheading,
   UILabelUsageProgress,
   UILabelUsageInfo,
   UILabelUsageWarning
} UILabelUsage;

@interface UIViewController ( Zest )

// If this controller participates in a tabbed and or navigation hierarchy, this property
// will return the UIViewController that is currently showing (i.e. selected tab and/or top of the nav stack).
@property (nonatomic, retain, readonly) UIViewController *foregroundViewController;

// Returns the controller that will be shown if this one gets popped off the navigation stack.
@property (nonatomic, retain, readonly) UIViewController *previousControllerInNavigationStack;

-(float)nextViewTop;

-(UIButton *)addButton:(NSString *)title action:(SEL)selector;
-(UILabel *)addLabelWithText: (NSString *)text usage: (UILabelUsage)usage;
-(UIActivityIndicatorView *)addActivityIndicator;
-(UIImageView *)addImageNamed:(NSString *)imageName;
-(UITextField *)addTextFieldWithPlaceholder:(NSString *)placeHolderText;
-(void)addContentView;
- (void)showAlertWithTitle: (NSString *)title message:(NSString *)message;
- (void)handleUnexpectedError: (NSError *) error;

// Provides an actionsheet-like mechanism for sliding simple views up over the 
// main view
- (void) slideViewUp: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background;
- (void) slideViewDown: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background;


- (CGRect)fullScreenViewBounds;

// Subclasses can override this to get notified when this controller is about to get popped.
// Requires use of DTNavigationController.
- (void)willPopOffOfNavigationStack;

// Subclasses can override this to get notified when they're about to appear due to the top view
// controller getting popped off the stack to reveal this view controller.
// Requires use of DTNavigationController.
- (void)controllerWillPopOffOfNavigationStack:(UIViewController *)topViewController;

// Subclasses can override this to get notified when this controller just got popped.
// Requires use of DTNavigationController.
- (void)didPopOffOfNavigationStack;

// Subclasses can override this to get notified when they just appeared due to the top view
// controller getting popped off the stack to reveal this view controller.
// Requires use of DTNavigationController.
- (void)controllerDidPopOffOfNavigationStack:(UIViewController *)topViewController;

// Subclasses can override this to get notified when this controller is about to get pushed onto the navigation stack.
// Requires use of DTNavigationController.
- (void)willGetPushedOntoNavigationStack;

// Subclasses can override this to get notified whenever a controller is about to get pushed on top of them.
// Requires use of DTNavigationController.
- (void)controllerWillGetPushedOntoNavigationStack:(UIViewController *)topViewController;

// Subclasses can override this to get notified when this controller just got pushed onto the navigation stack.
// Requires use of DTNavigationController.
- (void)didGetPushedOntoNavigationStack;

// Subclasses can override this to get notified whenever a controller just got pushed on top of them.
// Requires use of DTNavigationController.
- (void)controllerDidGetPushedOntoNavigationStack:(UIViewController *)topViewController;

// Useful for stubbing out actions that aren't complete yet.
// Pops up a friendly alert.
- (IBAction) notImplemented: (id) source;


@end