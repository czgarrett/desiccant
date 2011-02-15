//
//  DTGoogleAJAXSearchAPIParser.h
//
//  Created by Curtis Duhn on 2/1/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTResultObjectParser.h"


@interface DTGoogleAJAXSearchAPIParser : DTResultObjectParser {
	NSInteger currentPageIndex;
	NSArray *cursorPages;
}

@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic, retain) NSArray *cursorPages;

- (BOOL)hasMoreResults;
- (NSInteger)nextStartIndex;

@end
