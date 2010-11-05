//
//  UIButton+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 5/22/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "UIViewController+Zest.h"
 
@implementation UIViewController ( Zest )

-(UIButton *)addButton:(NSString *)title action:(SEL)selector
{
	UIButton *button = [UIButton buttonWithType: kButtonType];	
	button.frame = CGRectMake(kButtonLeft, [self nextViewTop], kButtonWidth, kButtonHeight);
	[button setTitle: title forState:UIControlStateNormal];
	button.backgroundColor = [UIColor clearColor];
	button.adjustsImageWhenDisabled = YES;	
	
	[button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];  
	[button setTitleColor: [UIColor whiteColor] forState: UIControlStateHighlighted];  
	[button setTitleColor: [UIColor grayColor] forState: UIControlStateDisabled];  
	[button setTitleColor: [UIColor whiteColor] forState: UIControlStateSelected];  
	
	[button addTarget: self action: selector forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: button];				
	return button;
}

-(UILabel *)addLabelWithText: (NSString *)text usage: (UILabelUsage)usage
{
	UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
	label.text = text;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = kLabelInfoColor;
	label.backgroundColor = [UIColor clearColor];
	switch (usage) {
		case UILabelUsageHeading:
			label.frame = CGRectMake(kMargin, [self nextViewTop], kClippedWidth, kLargeLabelHeight);
			label.font = [UIFont boldSystemFontOfSize: kLargeFontSize];
			break;
		case UILabelUsageSubheading:
			label.frame = CGRectMake(kMargin, [self nextViewTop], kClippedWidth, kSmallLabelHeight);
			label.font = [UIFont italicSystemFontOfSize: kSmallFontSize];
			break;
		case UILabelUsageProgress:
			label.frame = CGRectMake(kMargin, [self nextViewTop] + kPadding, kClippedWidth, kMediumLabelHeight);
			label.font = [UIFont systemFontOfSize: kMediumFontSize];
			label.textColor = kGoldColor;
			break;
		case UILabelUsageInfo:
			label.frame = CGRectMake(kMargin, [self nextViewTop] + kPadding, kClippedWidth, kMediumLabelHeight);
			label.font = [UIFont boldSystemFontOfSize: kMediumFontSize];
			label.textColor = kGoldColor;
			break;
		case UILabelUsageWarning:
			label.frame = CGRectMake(kMargin, [self nextViewTop] + kPadding, kClippedWidth, kMediumLabelHeight);
			label.font = [UIFont boldSystemFontOfSize: kSmallFontSize];
			label.textColor = [UIColor yellowColor];
			break;
	}
	[self.view addSubview: label];
	[label autorelease];
	return label;
		
}

-(UIImageView *)addImageNamed:(NSString *)imageName
{
	UIImageView *result = [[UIImageView alloc] initWithImage: [UIImage imageNamed: imageName]];
	[self.view addSubview: result];
	[result autorelease];
	return result;
}

-(UIActivityIndicatorView *)addActivityIndicator
{
	UIActivityIndicatorView *activityIndicator;
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	activityIndicator.hidesWhenStopped = YES;
	activityIndicator.center = CGPointMake(160.0, [self nextViewTop] + kPadding + 20.0);
	[self.view addSubview: activityIndicator];
	[activityIndicator autorelease];
	return activityIndicator;
}

-(void)addContentView
{
	//UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	UIView *contentView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"BackgroundGradient.jpg"]];
	contentView.userInteractionEnabled = YES;
	contentView.backgroundColor = kBackgroundColor;
	contentView.autoresizesSubviews = YES;
	self.view = contentView;	
	[contentView release];	
}

-(UITextField *)addTextFieldWithPlaceholder:(NSString *)placeholderText
{
	UITextField *result = [[UITextField alloc] initWithFrame: CGRectMake(kTextFieldLeft, [self nextViewTop], kTextFieldWidth, kTextFieldHeight)];
	result.placeholder = placeholderText;
	result.borderStyle = UITextBorderStyleBezel;
	result.backgroundColor = [UIColor whiteColor];
	result.delegate = (id <UITextFieldDelegate>) self;
	result.returnKeyType =  UIReturnKeyDone;
	[self.view addSubview: result];
	[result release];
	return result;
}

-(float)nextViewTop
{
	UIView *viewAbove = (UIView *) [[self.view subviews] lastObject];
	if (viewAbove) {
		return viewAbove.frame.origin.y + viewAbove.frame.size.height + kPadding;		
	} else {
		return kMargin;
	}
}

#pragma mark UI Conveniences

// Useful for stubbing out actions that aren't complete yet.
// Pops up a friendly alert.
- (IBAction) notImplemented: (id) source {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Not Implemented" 
                                                   message: @"This feature is not complete yet." 
                                                  delegate: nil 
                                         cancelButtonTitle: @"Ok" 
                                         otherButtonTitles: nil];
   [alert show];
   [alert release];
}


#pragma mark Custom actionsheet-like support

- (void) slideViewUp: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background {
   if (viewToSlide.superview != nil) {
      [viewToSlide removeFromSuperview];
   }
   UIWindow *window = [[UIApplication sharedApplication] keyWindow];
   [window addSubview: viewToSlide];
   viewToSlide.center = CGPointMake(160.0, 480.0 + viewToSlide.frame.size.height/2);
   [UIView beginAnimations: @"slideViewUp" context: nil];
   viewToSlide.center = CGPointMake(viewToSlide.center.x, viewToSlide.center.y - viewToSlide.frame.size.height);
   self.view.center = CGPointMake(self.view.center.x, self.view.center.y - background);      
   [UIView commitAnimations];
	viewToSlide.hidden = NO;
}

- (void) slideViewDown: (UIView *) viewToSlide slideBackgroundBy: (CGFloat) background {
   viewToSlide.hidden = YES;
   self.view.center = CGPointMake(self.view.center.x, self.view.center.y - background);      
   [viewToSlide removeFromSuperview];
}


#pragma mark Error Handling

- (void)handleUnexpectedError: (NSError *) error {
   NSString *description = [[error localizedDescription] stringByAppendingString: @"  The app may not function properly as a result."];
   [self showAlertWithTitle: @"Error" message: description];
}

- (CGRect)fullScreenViewBounds {
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	CGFloat width = appFrame.size.height;
	CGFloat height = appFrame.size.width;
	if (self.navigationController.navigationBar && !self.navigationController.isNavigationBarHidden) {
		height -= self.navigationController.navigationBar.bounds.size.height;
	}
	if (self.navigationController.toolbar && !self.navigationController.toolbarHidden) {
		height -= self.navigationController.toolbar.bounds.size.height;
	}
	if (self.tabBarController) {
		height -= self.tabBarController.tabBar.bounds.size.height;
	}
		
	return CGRectMake(0.0, 0.0, width, height);
}

- (UIViewController *)foregroundViewController {
	if ([self isKindOfClass:UITabBarController.class]) {
		if ([[(UITabBarController *)self selectedViewController] isKindOfClass:UINavigationController.class]) {
			return [(UINavigationController *)[(UITabBarController *)self selectedViewController] topViewController];
		}
		else {
			return [(UITabBarController *)self selectedViewController];
		}
	}
	else if (self.tabBarController) {
		return self.tabBarController.foregroundViewController;
	}
	else if ([self isKindOfClass:UINavigationController.class]) {
		return [(UINavigationController *)self topViewController];
	}
	else if (self.navigationController) {
		return self.navigationController.foregroundViewController;
	}
	else {
		return self;
	}
}

- (UIViewController *)previousControllerInNavigationStack {
	NSArray* viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1) {
		NSUInteger index = [viewControllers indexOfObject:self];
		if (index != NSNotFound && index > 0) {
			return [viewControllers objectAtIndex:index-1];
		}
	}
	
	return nil;	
}

#pragma mark Alerts 

- (void)errorAlertTitle: (NSString *)title message:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title 
												 message: message
												 delegate: nil 
												 cancelButtonTitle: @"Ok" 
												 otherButtonTitles: nil];
	[alert performSelectorOnMainThread: @selector(show) withObject: nil waitUntilDone: YES];
	[alert autorelease];												
	[self alertWithTitle:title message:message];
}

- (void)alertWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: self 
                                         cancelButtonTitle: @"Ok" 
                                         otherButtonTitles: nil];
   [alert show];
   [alert autorelease];   
}

- (void)confirmationWithTitle: (NSString *)title message: (NSString *)message {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                   message: message
                                                  delegate: self 
                                         cancelButtonTitle: @"Cancel" 
                                         otherButtonTitles: @"Ok", nil];
   [alert show];
   [alert autorelease];   
}

- (void) showAlertWithTitle: (NSString *) title message: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title 
                                                 message: message
                                                 delegate: self 
                                                 cancelButtonTitle: @"Ok" 
                                                 otherButtonTitles: nil];
    [alert performSelectorOnMainThread: @selector(show) withObject: nil waitUntilDone: YES];
    [alert autorelease];                                                
}

- (void)willPopOffOfNavigationStack {}
- (void)controllerWillPopOffOfNavigationStack:(UIViewController *)topViewController {}
- (void)didPopOffOfNavigationStack {}
- (void)controllerDidPopOffOfNavigationStack:(UIViewController *)topViewController {}

- (void)willGetPushedOntoNavigationStack {}
- (void)controllerWillGetPushedOntoNavigationStack:(UIViewController *)topViewController {}
- (void)didGetPushedOntoNavigationStack {}
- (void)controllerDidGetPushedOntoNavigationStack:(UIViewController *)topViewController {}

@end
