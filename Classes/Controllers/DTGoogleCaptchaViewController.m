//
//  DTGoogleCaptchaViewController.m
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

- (id)initWithCaptcha:(DTGoogleCaptcha *)theCaptcha delegate:(id <DTGoogleCaptchaViewControllerDelegate>)theDelegate {
	if (self = [super initWithNibName:[self captchaViewControllerNibName] bundle:nil]) {
		self.captcha = theCaptcha;
		captcha.delegate = self;
		self.delegate = theDelegate;
	}
	return self;
}

+ (id)controllerWithCaptcha:(DTGoogleCaptcha *)theCaptcha delegate:(id <DTGoogleCaptchaViewControllerDelegate>)theDelegate {
	return [[[self alloc] initWithCaptcha:theCaptcha delegate:theDelegate] autorelease];
}

#pragma mark UIViewController methods
- (void)viewDidLoad {
	[super viewDidLoad];
	[self refreshCaptcha];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.textField becomeFirstResponder];
}

#pragma mark Public methods to be overridden

- (NSString *)captchaViewControllerNibName {
	return @"DTGoogleCaptchaViewController";
}

#pragma mark IBActions

- (void)cancelClicked {
	[self.textField resignFirstResponder];
	if (self.captcha.isPostingResponse) {
		[self.captcha cancel];
		[self.activityIndicator stopAnimating];
	}
	[self.delegate captchaViewControllerWasCancelled:self];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[self.textField resignFirstResponder];
	[self.captcha postUserResponse:theTextField.text];
	return YES;
}

#pragma mark DTGoogleCaptchaDelegate methods

- (void)captcha:(DTGoogleCaptcha *)theCaptcha willPostResponse:(NSString *)response {
	[self.activityIndicator startAnimating];
//	self.imageView.hidden = YES;
	self.textField.hidden = YES;
}

- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response wasAcceptedReturningData:(NSData *)theData {
	[self.activityIndicator stopAnimating];
	[self.delegate captchaViewController:self didValidateSuccessfullyReturningData:theData];
}

- (void)captcha:(DTGoogleCaptcha *)theCaptcha response:(NSString *)response wasRejectedWithReplacementCaptcha:(BOOL)hasReplacement {
	[self.activityIndicator stopAnimating];
	if (hasReplacement) {
		[self refreshCaptcha];
		self.textField.hidden = NO;
		[self.textField becomeFirstResponder];
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
	[self.imageView loadFromURL:captcha.imageURL];
	self.textField.text = @"";
}


@end
