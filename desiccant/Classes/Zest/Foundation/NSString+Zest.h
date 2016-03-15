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
@property (nonatomic, retain, readonly) NSString *trimmed;
@property (nonatomic, retain, readonly) NSString *withResourcePathPrepended;
@property (nonatomic, retain, readonly) NSString *withCachesPathPrepended;
@property (nonatomic, retain, readonly) NSString *withDocumentPathPrepended;
@property (nonatomic, retain, readonly) NSString *withWhitespaceCollapsed;
@property (nonatomic, retain, readonly) NSString *withNewlinesRemoved;

// Returns the unmodified string unless its length is zero, in which case it
// returns nil.
@property (nonatomic, retain, readonly) NSString *unlessEmpty;

// Returns the resource path for the main bundle
+ (NSString *) resourcePath;
// Returns a file URL pointing to the resource directory.
+ (NSURL *) resourceURL;

// Returns the document path for the main bundle
+ (NSString *) documentPath;
// Returns a file URL pointing to the document directory.
+ (NSURL *) documentURL;

// Returns the caches path for the main bundle
+ (NSString *) cachesPath;
// Returns a file URL pointing to the caches directory.
+ (NSURL *) cachesURL;

+ (NSString *) stringWithContentsOfResource: (NSString *)resourceName ofType: (NSString *)fileExtension;
+ (NSString *) stringWithInteger:(NSInteger)integer;
+ (NSString *) stringWithData: (NSData *) data encoding: (NSStringEncoding) encoding;

+ (NSString *) stringWithGUID;

- (NSString *) stringByPrependingString:(NSString *)prefix;
- (NSString *) stringByAppendingNewLine:(NSString *)line;
- (BOOL)fileExists;
- (NSURL *) fileURLForPath;

@property (nonatomic, retain, readonly) NSString *HTMLUnencode;

// Truncates self to given length if its length is longer.  Adds an ellipsis character at the end if truncated.
// Returns a copy of self if its length length is shorter than the given length. 
- (NSString *) stringTruncatedToLength: (NSInteger)length;

// returns YES if the receiver's uppercase string is equal to YES, TRUE, 1, or ON
// returns NO if the receiver's uppercase string is equal to NO, FALSE, 0, OFF, or empty string
- (BOOL) boolValue;

@property(readonly) BOOL vowel;
@property(readonly) BOOL consonant;
// Returns true if this string is the file extension of an image that can be handled by UIImage
- (BOOL) isImageExtension;
- (BOOL) startsWith:(NSString *)prefix;
- (BOOL)contains:(NSString *)substring;

// Regex helpers
- (BOOL)containsRegex:(NSString *)regex;
- (NSString *) stringByMatching: (NSString *) regexString capture: (NSInteger) captureGroup;
- (NSArray *) componentsMatchedByRegex: (NSString *) regexString;
- (NSString *) stringByReplacingOccurrencesOfRegex: (NSString *) regexString withString: (NSString *) replacement;

- (BOOL)containsOnlyCharactersFromSet:(NSCharacterSet *)set;
- (BOOL)isEmpty;
// Returns a range with index 0 and length = [self length]
- (NSRange) range;

- (NSString *) concatenateTimes: (NSInteger) times;

- (NSString *) pluralize;

// Useful for mixing up NSString objects with NSNumber.  Returns self.
- (NSString *) stringValue;

- (NSNumber *) integerNumber;


@end
