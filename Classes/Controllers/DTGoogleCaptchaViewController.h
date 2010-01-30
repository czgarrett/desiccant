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

@interface DTGoogleCaptchaViewController : DTViewController {
	DTGoogleCaptcha *captcha;
}

@property (nonatomic, retain) DTGoogleCaptcha *captcha;

- (id)initWithCaptcha:(DTGoogleCaptcha *)theCaptcha;
+ (id)controllerWithCaptcha:(DTGoogleCaptcha *)theCaptcha;

@end
