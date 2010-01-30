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

@property (nonatomic, retain, readonly) NSString *to_resource_path;
@property(readonly) BOOL empty;

// Returns the resource path for the main bundle
+ (NSString *) resourcePath;
// Returns a file URL pointing to the resource directory.
+ (NSString *) resourceURL;

// Returns the document path for the main bundle
+ (NSString *) documentPath;
// Returns a file URL pointing to the document directory.
+ (NSString *) documentURL;

// Returns the caches path for the main bundle
+ (NSString *) cachesPath;
// Returns a file URL pointing to the caches directory.
+ (NSString *) cachesURL;

+ (NSString *) stringWithContentsOfResource: (NSString *)resourceName ofType: (NSString *)fileExtension;
+ (NSString *) stringWithInteger:(NSInteger)integer;

- (NSString *) stringByPrependingString:(NSString *)prefix;
- (NSString *) stringByAppendingNewLine:(NSString *)line;
- (NSString *) withResourcePathPrepended;
- (NSString *) withCachesPathPrepended;
- (NSString *) withDocumentPathPrepended;
- (BOOL)fileExists;
- (NSURL *) fileURLForPath;

- (NSString *) HTMLUnencode;

// Truncates self to given length if its length is longer.  Adds an ellipsis character at the end if truncated.
// Returns a copy of self if its length length is shorter than the given length. 
- (NSString *) stringTruncatedToLength: (NSInteger)length;

// Returns true if this string is the file extension of an image that can be handled by UIImage
- (BOOL) isImageExtension;
- (BOOL) startsWith:(NSString *)prefix;
- (BOOL)containsOnlyCharactersFromSet:(NSCharacterSet *)set;

@end
