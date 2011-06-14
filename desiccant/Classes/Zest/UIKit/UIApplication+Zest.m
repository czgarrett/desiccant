//
//  UIApplication+Zest.m
//  NoteToSelf
//
//  Created by Curtis Duhn on 7/21/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "UIApplication+Zest.h"
#import "Zest.h"

@implementation UIApplication(Zest)

- (void)bcompat_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
	if (DTOSVersion >= 3.2) {
		[self setStatusBarHidden:hidden withAnimation:animation]; 
	}
	else {
		BOOL animated = (BOOL)animation;
		[self performSelector:@selector(setStatusBarHidden:animated:) withReturnValueAndArguments:nil, &hidden, &animated, nil];
	}
}

+ (NSString *)versionNumberString {
	return [[[NSBundle mainBundle] infoDictionary] stringForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleName {
	return [[[NSBundle mainBundle] infoDictionary] stringForKey:@"CFBundleName"];
}


+ (NSString *)buildNumberString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
	NSString *timeString = [NSString stringWithCString:__TIME__ encoding:NSUTF8StringEncoding];
	NSString *dateString = [NSString stringWithCString:__DATE__ encoding:NSUTF8StringEncoding];
	NSString *timeStampString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
	NSDate *buildDate = [formatter dateFromString:timeStampString];
	NSTimeInterval seconds = [buildDate timeIntervalSinceReferenceDate];
	return [NSString stringWithFormat:@"%d", (NSInteger)seconds - 290000000];
}

@end


@interface FixCategoryBugUIApplication : NSObject {}
@end
@implementation FixCategoryBugUIApplication
@end
