//
//  DTGoogleCaptchaViewController.m
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleCaptchaViewController.h"
#import "Zest.h"

@interface DTGoogleCaptchaViewController()
- (void)refreshCaptcha;
@end

@implementation DTGoogleCaptchaViewController
@synthesize captcha, textField, promptLabel, imageView, cancelButton, delegate;

#pragma mark Memory management

- (void)dealloc {
	self.textField.delegate = nil;
	self.imageView.delegate = nil;
	self.captcha.delegate = nil;
	
	self.captcha = nil;
	self.textField = nil;
	self.promptLabel = nil;
	self.imageView = nil;
	self.cancelButton = nil;
	self.delegate = nil;
	
    [super dealloc];
}

#pragma mark Constructors

- (id)initWithCaptcha:(DTGoogleCaptcha *)theCaptcha {
	if (self = [super initWithNibName:[self captchaViewControllerNibName] bundle:nil]) {
		self.captcha = theCaptcha;
	}
	return self;
}

+ (id)controllerWithCaptcha:(DTGoogleCaptcha *)theCaptcha {
	return [[[self alloc] initWithCaptcha:theCaptcha] autorelease];
}

#pragma mark UIViewController methods
- (void)viewDidLoad {
	[self refreshCaptcha];
}

#pragma mark Public methods to be overridden

- (NSString *)captchaViewControllerNibName {
	return @"DTGoogleCaptchaViewController";
}

#pragma mark IBActions

- (void)cancelClicked {
	if (self.captcha.isPostingResponse) {
		[self.captcha cancel];
		[self.activityIndicator stopAnimating];
	}
	[self.delegate captchaViewControllerWasCancelled:self];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[self.captcha postUserResponse:theTextField.text];
	return YES;
}

#pragma mark DTGoogleCaptchaDelegate methods

- (void)captcha:(DTGoogleCaptcha *)theCaptcha willPostResponse:(NSString *)response {
	[self.activityIndicator startAnimating];
}

- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response wasRejectedWithReplacementCaptcha:(BOOL)hasReplacement {
	[self.activityIndicator stopAnimating];
	if (hasReplacement) {
		[self refreshCaptcha];
	}
	else {
		[self.delegate captchaViewController:self 
							didFailWithError:[NSError errorWithDomain:@"DTGoogleCaptchaViewControllerError" 
																 code:DTGoogleCaptchaViewControllerErrorRejectedWithoutReplacement 
															 userInfo:[NSDictionary dictionaryWithObject:@"Google rejected the CAPTCHA response." 
																								  forKey:NSLocalizedDescriptionKey]]];
	}
}

- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response didFailWithError:(NSError *)error {
	[self.activityIndicator stopAnimating];
	[self.delegate captchaViewController:self didFailWithError:error];
}

#pragma mark DTImageViewDelegate methods

- (void)imageView:(DTImageView *)imageView didFailLoadingWithError:(NSError *)error {
	[self.delegate captchaViewController:self didFailWithError:error];
}

- (void)imageViewDidFinishLoading:(DTImageView *)imageView {
}

#pragma mark Private methods

- (void)refreshCaptcha {
	[self.imageView loadFromURL:captcha.imageURLString.to_url];
	self.textField.text = @"";
}


@end
