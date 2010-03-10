//
//  DTGoogleCaptchaViewController.h
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGoogleCaptcha.h"
#import "DTViewController.h"
#import "DTImageViewDelegate.h"

// Errors
enum DTGoogleCaptchaViewControllerError {
	DTGoogleCaptchaViewControllerErrorRejectedWithoutReplacement
};

@class DTGoogleCaptchaViewController;

@protocol DTGoogleCaptchaViewControllerDelegate <NSObject>
- (void) captchaViewControllerWasCancelled:(DTGoogleCaptchaViewController *)controller;
- (void) captchaViewController:(DTGoogleCaptchaViewController *)controller didFailWithError:(NSError *)error;
- (void) captchaViewControllerDidValidateSuccessfully:(DTGoogleCaptchaViewController *)controller;
@end

@interface DTGoogleCaptchaViewController : DTViewController <UITextFieldDelegate, DTImageViewDelegate> {
	DTGoogleCaptcha *captcha;
	IBOutlet UITextField *textField;
	IBOutlet UILabel *promptLabel;
	IBOutlet DTImageView *imageView;
	IBOutlet UIButton *cancelButton;
	id <DTGoogleCaptchaViewControllerDelegate> delegate;
}

@property (nonatomic, retain) DTGoogleCaptcha *captcha;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet DTImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, assign) id <DTGoogleCaptchaViewControllerDelegate> delegate;

- (id)initWithCaptcha:(DTGoogleCaptcha *)theCaptcha;
+ (id)controllerWithCaptcha:(DTGoogleCaptcha *)theCaptcha;

// Subclasses may override this and return a custom Nib name if they don't want to use the default
// Nib from desiccant's resources.  The default is DTGoogleCaptchaViewController.xib.
- (NSString *)captchaViewControllerNibName;

- (IBAction)cancelClicked;

@end
