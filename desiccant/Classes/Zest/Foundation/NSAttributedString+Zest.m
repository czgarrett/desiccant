//
//  NSAttributedString+Zest.m
//  medaxion
//
//  Created by Christopher Garrett on 7/11/14.
//
//

#import "NSAttributedString+Zest.h"

@implementation NSAttributedString (Zest)

+ (instancetype) attributedStringWithString: (NSString *) string {
    if (string) {
        return [[[self class] alloc] initWithString: string];
    } else {
        return nil;
    }
}

+ (instancetype) attributedStringWithString: (NSString *) string attributes: (NSDictionary *)attr {
    if (string) {
        return [[[self class] alloc] initWithString: string attributes: attr];
    } else {
        return nil;
    }
}

@end
