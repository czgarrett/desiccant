//
//  NSAttributedString+Zest.h
//  medaxion
//
//  Created by Christopher Garrett on 7/11/14.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Zest)

// Returns nil if the string is nil
+ (instancetype) attributedStringWithString: (NSString *) string;
+ (instancetype) attributedStringWithString: (NSString *) string attributes: (NSDictionary *)attr;

@end
