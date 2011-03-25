//
//  NSHTTPURLResponse+Zest.m
//
//  Created by Curtis Duhn on 1/22/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSHTTPURLResponse+Zest.h"
#import "NSDictionary+Zest.h"

NSString * const NSHTTPURLResponseErrorDomain = @"NSHTTPURLResponseErrorDomain";

@implementation NSHTTPURLResponse (Zest)

- (NSError *)httpError {
	if ([self statusCode] >= 400) {
		return [NSError errorWithDomain:NSHTTPURLResponseErrorDomain 
								   code:[self statusCode] 
							   userInfo:[NSDictionary dictionaryWithObject:[NSHTTPURLResponse localizedStringForStatusCode:[self statusCode]] 
																	forKey:NSLocalizedDescriptionKey]];
	}
	else {
		return nil;
	}
}

- (NSString *)httpContentType {
	return [[[self allHeaderFields] dictionaryWithLowercaseKeys] stringForKey:@"content-type"];
}


@end


@interface FixCategoryBugNSHTTPURLResponse : NSObject {}
@end
@implementation FixCategoryBugNSHTTPURLResponse
@end