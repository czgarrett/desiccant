//
//  NSMutableURLRequest+Zest.m
//  BlueDevils
//
//  Created by Curtis Duhn on 4/1/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "NSMutableURLRequest+Zest.h"
#import "NSDictionary+Zest.h"
#import "NSString+Zest.h"

@implementation NSMutableURLRequest(Zest)

- (void)setPostParameters:(NSDictionary *)postParameters {
	if (postParameters) {
		[self setHTTPMethod:@"POST"];
		NSData *queryStringData = [[postParameters toQueryString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

		[self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[self setValue:[NSString stringWithInteger:[queryStringData length]] forHTTPHeaderField:@"Content-Length"];
		[self setHTTPBody:[NSData dataWithBytes:[queryStringData bytes] length:[queryStringData length]]];
	}
}

@end


@interface FixCategoryBugNSMutableURLRequest : NSObject {}
@end
@implementation FixCategoryBugNSMutableURLRequest
@end