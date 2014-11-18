//
//  String+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSString+Zest.h"
#import "NSObject+Zest.h"



@implementation NSString ( Zest )

+ (NSString *) stringWithContentsOfResource: (NSString *)resourceName ofType: (NSString *)fileExtension {
	NSStringEncoding usedEncoding;
	NSError *error;
   return [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: resourceName ofType: fileExtension] usedEncoding:&usedEncoding error:&error];
}

+ (NSString *) resourcePath {
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSURL *) resourceURL {
	return [NSURL fileURLWithPath:[self resourcePath]];
}

+ (NSString *) documentPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSURL *) documentURL {
	return [NSURL fileURLWithPath:[self documentPath]];
}

+ (NSString *) cachesPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSURL *) cachesURL {
	return [NSURL fileURLWithPath:[self cachesPath]];
}

+ (NSString *) stringWithInteger:(NSInteger)integer {
	return [NSString stringWithFormat:@"%ld", (long)integer];
}

+ (NSString *) stringWithData: (NSData *) data encoding: (NSStringEncoding) encoding {
   return [[NSString alloc] initWithData: data encoding: encoding];
}

+ (NSString *) stringWithGUID {
   CFUUIDRef theUUID = CFUUIDCreate(NULL);
   NSString *string = CFBridgingRelease(CFUUIDCreateString(NULL, theUUID));
   CFRelease(theUUID);
   return string;
}

- (NSString *) pluralize {
   return [self stringByAppendingString: @"s"];
}

- (NSString *) to_s {
    return self;
}

- (NSString *) stringValue {
   return self;
}


- (NSInteger) to_i {
    return [[self to_n] integerValue];
}

- (NSURL *) to_url {
    return [NSURL URLWithString:self];
}

- (NSNumber *) to_n {
    NSScanner *scanner = [NSScanner scannerWithString:[self stringByReplacingOccurrencesOfString:@"," withString:@""]];
    double doubleValue;
    NSInteger integerValue;
    if ([scanner scanDouble:&doubleValue]) {
        return [NSNumber numberWithDouble:doubleValue];
    }
    else if ([scanner scanInteger:&integerValue]) {
        return [NSNumber numberWithInteger:integerValue];
    }
    else {
        return nil;
    }
}

- (double) to_double {
    return [[self to_n] doubleValue];
}

- (NSNumber *) integerNumber {
   return [NSNumber numberWithInteger: [self integerValue]];
}

- (BOOL) isEqualToNumber: (NSNumber *) number {
    NSAssert(NO, @"This string isn't a number silly!");
    return NO;
}


- (NSString *)trimmed {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)to_resource_path {
    return [self withResourcePathPrepended];
}

- (NSString *)stringByAppendingNewLine:(NSString *)line {
	if (line) {
		if ([self length] == 0) {
			return [self stringByAppendingString:line];
		}
		else {
			return [NSString stringWithFormat:@"%@\n%@", self, line];
		}
	}
	else {
		return self;
	}
}

- (NSString *)stringByPrependingString:(NSString *)prefix {
	return [prefix stringByAppendingString:self];
}

- (NSString *)withResourcePathPrepended {
    return [[NSBundle mainBundle] pathForResource:self ofType:nil];
}

- (NSString *)withCachesPathPrepended {
	return [[NSString cachesPath] stringByAppendingPathComponent:self];
}

- (NSString *)withDocumentPathPrepended {
	return [[NSString documentPath] stringByAppendingPathComponent:self];
}

- (BOOL)fileExists {
	return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (NSURL *) fileURLForPath {
	return [NSURL fileURLWithPath:self];
}

- (NSDate *) to_date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    NSDate *date = [dateFormatter dateFromString:self];
    // if (date == nil) { } - uncomment this if you want to handle failures

    return date;
}

- (NSString *) HTMLUnencode {
   NSString *result;
   result = [self stringByReplacingOccurrencesOfString: @"&lt;" withString: @"<"];
   result = [result stringByReplacingOccurrencesOfString: @"&gt;" withString: @">"];
   result = [result stringByReplacingOccurrencesOfString: @"&nbsp;" withString: @" "];
   return result;
}

- (NSString *) stringTruncatedToLength: (NSInteger)length {
   if ([self length] > length) {
      return [NSString stringWithFormat: @"%@…", [self substringToIndex: length - 1]];
   } else {
      return [self copy];
   }
}

- (BOOL) empty {
   return [self length] == 0;
}

- (BOOL) vowel {
   NSRange foundRange = [@"AEIOU" rangeOfString: [self uppercaseString]];
   return foundRange.location != NSNotFound;
}

- (BOOL) consonant {
   return !self.vowel;
}

// returns YES if the receiver's uppercase string is equal to YES, TRUE, 1, or ON
// returns NO for all other values
- (BOOL) boolValue {
   NSString *caps = [self uppercaseString];
   return   [caps isEqualToString: @"YES"] || [caps isEqualToString: @"TRUE"] ||
            [caps isEqualToString: @"1"]   || [caps isEqualToString: @"ON"];
}


- (BOOL) isImageExtension {
    return 
    [self isEqual:@"jpg"] ||
    [self isEqual:@"jpeg"] ||
    [self isEqual:@"png"] ||
    [self isEqual:@"gif"] ||
    [self isEqual:@"tif"] ||
    [self isEqual:@"tiff"] ||
    [self isEqual:@"bmp"] ||
    [self isEqual:@"BMPf"] ||
    [self isEqual:@"ico"] ||
    [self isEqual:@"cur"] ||
    [self isEqual:@"xbm"];
}

- (BOOL) startsWith:(NSString *)prefix {
    return [self hasPrefix:prefix];
}

- (BOOL)contains:(NSString *)substring {
	return [self rangeOfString:substring].location != NSNotFound;
}

- (BOOL)containsRegex:(NSString *)regexString {
   NSError *error = NULL;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                             options:NSRegularExpressionCaseInsensitive
                                               error:&error];
   if (error) {
      return NO;
   } else {
      NSTextCheckingResult *match = [regex firstMatchInString: self options: 0 range: [self range]];
      return match != nil;
   }
}

- (NSString *) stringByMatching: (NSString *) regexString capture: (NSInteger) captureGroup {
   NSError *error = NULL;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString
                                                                          options: 0
                                                                            error: &error];
   if (!error) {
      NSTextCheckingResult *match = [regex firstMatchInString: self options:0 range: NSMakeRange(0, [self length])];
      if (match && [match numberOfRanges] >= captureGroup) {
         NSRange matchRange = [match rangeAtIndex: captureGroup];
         return [self substringWithRange: matchRange];
      } else {
         return nil;
      }
   } else {
      return nil;
   }
}

- (NSRange) range {
   return NSMakeRange(0, [self length]);
}

- (NSArray *) componentsMatchedByRegex: (NSString *) regexString {
    NSError *error = NULL;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString
                                                                          options: 0
                                                                            error: &error];
   if (!error) {
      NSArray *matches = [regex matchesInString: self options: 0 range: [self range]];
      NSMutableArray *result = [NSMutableArray array];
      for (NSTextCheckingResult *match in matches) {
         [result addObject: [self substringWithRange: [match range]]];
      }
      return result;
   } else {
      return [NSArray array];
   }
}

- (NSString *) stringByReplacingOccurrencesOfRegex: (NSString *) regexString withString: (NSString *) replacement {
   NSMutableString *result =[NSMutableString string];
   NSInteger currentLocation = 0;
   NSError *error = nil;
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString
                                                                          options: 0
                                                                            error: &error];
   if (!error) {
      NSArray *matches = [regex matchesInString: self options: 0 range: [self range]];
      for (NSTextCheckingResult *match in matches) {
         NSRange matchRange = [match range];
         [result appendString: [self substringWithRange: NSMakeRange(currentLocation, matchRange.location - currentLocation)]];
         [result appendString: replacement];
         currentLocation = matchRange.location + matchRange.length;
      }
      [result appendString: [self substringWithRange: NSMakeRange(currentLocation, [self length] - currentLocation)]];
   }
   return result;
}

- (NSString *) concatenateTimes: (NSInteger) times {
    NSMutableString *result = [NSMutableString string];
    for (int i=0; i<times; i++) {
        [result appendString: self];
    }
    return result;
}


- (BOOL)containsOnlyCharactersFromSet:(NSCharacterSet *)set {
	return [[self stringByTrimmingCharactersInSet:set] length] == 0;
}

- (BOOL)isEmpty {
	return [self length] == 0;
}

- (NSString *)withWhitespaceCollapsed {
	return [self stringByReplacingOccurrencesOfRegex:@"[ \\t]+" withString:@" "];
}

- (NSString *)withNewlinesRemoved {
	return [self stringByReplacingOccurrencesOfRegex:@"\\n" withString:@" "];
}

- (NSString *)unlessEmpty {
	return [self length] ? self : nil;
}

- (NSString *)stringByAddingPercentEscapesIncludingLegalCharactersUsingEncoding:(NSStringEncoding)encoding {
	NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
															   NULL,
															   (CFStringRef)self,
															   NULL,
															   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
															   CFStringConvertNSStringEncodingToEncoding(encoding)));
    return result;
}


@end

@interface FixCategoryBugNSString : NSObject {}
@end
@implementation FixCategoryBugNSString
@end