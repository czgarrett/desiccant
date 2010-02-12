//
//  DTGoogleAJAXSearchAPIParser.m
//  PortablePTO
//
//  Created by Curtis Duhn on 2/1/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import "DTGoogleAJAXSearchAPIParser.h"
#import "Zest.h"

@interface DTGoogleAJAXSearchAPIParser()
@end

@implementation DTGoogleAJAXSearchAPIParser
@synthesize cursorPages, currentPageIndex;

- (void)dealloc {
	self.cursorPages = nil;
	
	[super dealloc];
}

- (BOOL)parseDictionarySuccessfully:(NSDictionary *)dictionary {
	self.rows = nil;
	self.cursorPages = nil;
	self.currentPageIndex = 0;
	
	NSDictionary *responseData = [dictionary dictionaryForKey:@"responseData"];
	if (!responseData) {
		self.errorString = @"Response doesn't have a responseData key";
		return NO;
	}
	self.rows = [responseData arrayForKey:@"results"];
	if (rows) {
		NSDictionary *cursor = [responseData dictionaryForKey:@"cursor"];
		if (cursor) {
			self.currentPageIndex = [cursor integerForKey:@"currentPageIndex"];
			self.cursorPages = [cursor arrayForKey:@"pages"];
		}
		return YES;
	}
	else {
		self.errorString = @"responseData doesn't have a results key";
		return NO;
	}
}

- (BOOL)hasMoreResults {
	return (cursorPages &&
			currentPageIndex + 1 <= [cursorPages count] - 1);
}

- (NSInteger)nextStartIndex {
	if ([self hasMoreResults]) {
		return [[cursorPages dictionaryAtIndex:currentPageIndex + 1] integerForKey:@"start"];
	}
	else {
		return 0;
	}
}




@end
