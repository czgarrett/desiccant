//
//  String+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#define nss(s) ((NSString *)(s))
#define nssWithFormat(...) ((NSString *)[NSString stringWithFormat:__VA_ARGS__])

@interface NSString ( Zest )


- (NSString *) HTMLUnencode;

// Truncates self to given length if its length is longer.  Adds an ellipsis character at the end if truncated.
// Returns a copy of self if its length length is shorter than the given length. 
- (NSString *) stringTruncatedToLength: (NSInteger)length;

@property (nonatomic, retain, readonly) NSString *to_resource_path;
@property(readonly) BOOL empty;

@end
