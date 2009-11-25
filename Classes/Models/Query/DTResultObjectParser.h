//
//  DTResultObjectParser.h
//  PortablePTO
//
//  Created by Curtis Duhn on 11/21/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//


@protocol DTResultObjectParser
- (BOOL)parseArraySuccessfully:(NSArray *)array;
- (BOOL)parseDictionarySuccessfully:(NSDictionary *)dictionary;
- (NSArray *)rows;
- (NSString *)errorString;

@end
