//
//  DTCaptcha.m
//  PortablePTO
//
//  Created by Curtis Duhn on 1/27/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleCaptcha.h"
#import "Zest.h"

@interface DTGoogleCaptcha()
- (BOOL)parseData:(NSData *)data;
@end

@implementation DTGoogleCaptcha

//- (void)dealloc {
//    [super dealloc];
//}

- (id)initWithHTMLData:(NSData *)theData {
	if (self = [super init]) {
		unless ([self parseData:theData]) {
			[self release];
			return nil;
		}
	}
	return self;
}

+ (id)captchaWithHTMLData:(NSData *)theData {
	return [[[self alloc] initWithHTMLData:theData] autorelease];
}

- (BOOL)parseData:(NSData *)data {
	NSAssert (0, @"Finish me");
	return NO;
}

@end
