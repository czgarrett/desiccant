//
//  String+Zest.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegexKitLite.h"
#import "GTMNSString+HTML.h"

#define nss(s) ((NSString *)(s))
#define nssWithFormat(...) ((NSString *)[NSString stringWithFormat:__VA_ARGS__])

@interface NSString ( Zest )

@property (nonatomic, retain, readonly) NSString *to_resource_path;
@property(readonly) BOOL empty;
@property (nonatomic, retain, readonly) NSString *trimmed;

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
- (BOOL)isEmpty;
- (NSString *)stringByRemovingMarkupTags;

/// Get a string where internal characters that need escaping for HTML are escaped 
//
///  For example, '&' become '&amp;'. This will only cover characters from table
///  A.2.2 of http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
///  which is what you want for a unicode encoded webpage. If you have a ascii
///  or non-encoded webpage, please use stringByEscapingAsciiHTML which will
///  encode all characters.
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)stringByEscapingForHTML;

/// Get a string where internal characters that need escaping for HTML are escaped 
//
///  For example, '&' become '&amp;'
///  All non-mapped characters (unicode that don't have a &keyword; mapping)
///  will be converted to the appropriate &#xxx; value. If your webpage is
///  unicode encoded (UTF16 or UTF8) use stringByEscapingHTML instead as it is
///  faster, and produces less bloated and more readable HTML (as long as you
///  are using a unicode compliant HTML reader).
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)stringByEscapingForAsciiHTML;

/// Get a string where internal characters that are escaped for HTML are unescaped 
//
///  For example, '&amp;' becomes '&'
///  Handles &#32; and &#x32; cases as well
///
//  Returns:
//    Autoreleased NSString
//
- (NSString *)stringByUnescapingFromHTML;

@end
