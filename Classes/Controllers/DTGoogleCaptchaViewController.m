//
//  DTGoogleCaptchaViewController.m
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleCaptchaViewController.h"


@interface DTGoogleCaptchaViewController()
@end

@implementation DTGoogleCaptchaViewController
@synthesize captcha;

- (void)dealloc {
	self.captcha = nil;
    [super dealloc];
}

- (id)initWithCaptcha:(DTGoogleCaptcha *)theCaptcha {
	if (self = [super init]) {
		self.captcha = theCaptcha;
	}
	return self;
}

+ (id)controllerWithCaptcha:(DTGoogleCaptcha *)theCaptcha {
	return [[[self alloc] initWithCaptcha:theCaptcha] autorelease];
}

@end
