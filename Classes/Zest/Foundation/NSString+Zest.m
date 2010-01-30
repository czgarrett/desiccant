//
//  String+Zest.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 10/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "NSString+Zest.h"


@implementation NSString ( Zest )

+ (NSString *) stringWithContentsOfResource: (NSString *)resourceName ofType: (NSString *)fileExtension {
	NSStringEncoding usedEncoding;
	NSError *error;
   return [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: resourceName ofType: fileExtension] usedEncoding:&usedEncoding error:&error];
}

+ (NSString *) resourcePath {
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *) resourceURL {
	return [NSURL fileURLWithPath:[self resourcePath]];
}

+ (NSString *) documentPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *) documentURL {
	return [NSURL fileURLWithPath:[self documentPath]];
}

+ (NSString *) cachesPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *) cachesURL {
	return [NSURL fileURLWithPath:[self cachesPath]];
}

+ (NSString *) stringWithInteger:(NSInteger)integer {
	return [NSString stringWithFormat:@"%d", integer];
}

- (NSString *) to_s {
    return self;
}

- (NSInteger) to_i {
    return [self integerValue];
}

- (NSURL *) to_url {
    return [NSURL URLWithString:self];
}

- (NSNumber *) to_n {
    NSScanner *scanner = [NSScanner scannerWithString:self];
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
    return [self doubleValue];
}

- (NSString *)to_resource_path {
    return [self withResourcePathPrepended];
}

- (NSString *)stringByAppendingNewLine:(NSString *)line {
	if (line) {
		return [NSString stringWithFormat:@"%@\n%@", self, line];
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
    [dateFormatter release];

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
      return [[self copy] autorelease];
   }
}

- (BOOL) empty {
   return [self length] == 0;
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

- (BOOL)containsOnlyCharactersFromSet:(NSCharacterSet *)set {
	return [[self stringByTrimmingCharactersInSet:set] length] == 0;
}

@end
