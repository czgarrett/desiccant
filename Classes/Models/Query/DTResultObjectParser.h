//
//  DTResultObjectParser.h
//  PortablePTO
//
//  Created by Curtis Duhn on 12/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "desiccant.h"

@protocol DTResultObjectParser
- (BOOL)parseArraySuccessfully:(NSArray *)array;
- (BOOL)parseDictionarySuccessfully:(NSDictionary *)dictionary;
- (NSArray *)rows;
- (NSString *)errorString;
@end

@interface DTResultObjectParser : NSObject <DTResultObjectParser> {
	NSArray *rows;
	NSString *errorString;
}

@property (nonatomic, retain) NSArray *rows;
@property (nonatomic, retain) NSString *errorString;

+ (id)parser;

@end
