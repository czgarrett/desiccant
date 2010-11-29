//
//  ASIDataCompressorTests.m
//  Mac
//
//  Created by Ben Copsey on 17/08/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//
// Sadly these tests only work on Mac because of the dependency on NSTask, but I'm fairly sure this class should behave in the same way on iOS

#import "ASIDataCompressorTests.h"
#import "ASIDataCompressor.h"
#import "ASIDataDecompressor.h"
#import "ASIHTTPRequest.h"

@implementation ASIDataCompressorTests


- (void)testInflateData
{
	// Test in-memory inflate using uncompressData:error:
	NSUInteger i;
	
	NSString *originalString = [NSString string];
	for (i=0; i<1000; i++) {
		originalString = [originalString stringByAppendingFormat:@"This is line %i\r\n",i];
	}
	
	NSError *error = nil;
	NSString *filePath = [[self filePathForTemporaryTestFiles] stringByAppendingPathComponent:@"uncompressed_file.txt"];
	NSString *gzippedFilePath = [[self filePathForTemporaryTestFiles] stringByAppendingPathComponent:@"uncompressed_file.txt.gz"];
	[ASIHTTPRequest removeFileAtPath:gzippedFilePath error:&error];
	if (error) {
		GHFail(@"Failed to remove old file, cannot proceed with test");
	}	
	[originalString writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		GHFail(@"Failed to write string, cannot proceed with test");
	}
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/usr/bin/gzip"];
	[task setArguments:[NSArray arrayWithObject:filePath]];
	[task launch];
	[task waitUntilExit];
	
	NSData *deflatedData = [NSData dataWithContentsOfFile:gzippedFilePath];
	
	NSData *inflatedData = [ASIDataDecompressor uncompressData:deflatedData error:&error];
	if (error) {
		GHFail(@"Inflate failed because %@",error);
	}
	
	NSString *inflatedString = [[[NSString alloc] initWithBytes:[inflatedData bytes] length:[inflatedData length] encoding:NSUTF8StringEncoding] autorelease];

	
	BOOL success = [inflatedString isEqualToString:originalString];
	GHAssertTrue(success,@"inflated data is not the same as original");
	
	// Test file to file inflate
	NSString *inflatedFilePath = [[self filePathForTemporaryTestFiles] stringByAppendingPathComponent:@"inflated_file.txt"];
	[ASIHTTPRequest removeFileAtPath:inflatedFilePath error:&error];
	if (error) {
		GHFail(@"Failed to remove old file, cannot proceed with test");
	}
	
	if (![ASIDataDecompressor uncompressDataFromFile:gzippedFilePath toFile:inflatedFilePath error:&error]) {
		GHFail(@"Inflate failed because %@",error);
	}
	
	originalString = [NSString stringWithContentsOfFile:inflatedFilePath encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		GHFail(@"Failed to read the inflated data, cannot proceed with test");
	}	
	
	success = [inflatedString isEqualToString:originalString];
	GHAssertTrue(success,@"inflated data is not the same as original");
	
}

- (void)testDeflateData
{
	// Test in-memory deflate using compressData:error:
	NSUInteger i;
	
	NSString *originalString = [NSString string];
	for (i=0; i<1000; i++) {
		originalString = [originalString stringByAppendingFormat:@"This is line %i\r\n",i];
	}
	NSError *error = nil;
	NSData *deflatedData = [ASIDataCompressor compressData:[originalString dataUsingEncoding:NSUTF8StringEncoding] error:&error];
	if (error) {
		GHFail(@"Failed to deflate the data");
	}
	
	NSString *gzippedFilePath = [[self filePathForTemporaryTestFiles] stringByAppendingPathComponent:@"uncompressed_file.txt.gz"];
	[ASIHTTPRequest removeFileAtPath:gzippedFilePath error:&error];
	if (error) {
		GHFail(@"Failed to remove old file, cannot proceed with test");
	}	
	
	[deflatedData writeToFile:gzippedFilePath options:0 error:&error];
	if (error) {
		GHFail(@"Failed to write data, cannot proceed with test");
	}
	
	NSString *filePath = [[self filePathForTemporaryTestFiles] stringByAppendingPathComponent:@"uncompressed_file.txt"];
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/usr/bin/gzip"];
	[task setArguments:[NSArray arrayWithObjects:@"-d",gzippedFilePath,nil]];
	[task launch];
	[task waitUntilExit];
	
	NSString *inflatedString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	if (error) {
		GHFail(@"Failed to read the inflated data, cannot proceed with test");
	}	
	
	BOOL success = [inflatedString isEqualToString:originalString];
	GHAssertTrue(success,@"inflated data is not the same as original");
	
	
	// Test file to file deflate
	[ASIHTTPRequest removeFileAtPath:gzippedFilePath error:&error];
	
	if (![ASIDataCompressor compressDataFromFile:filePath toFile:gzippedFilePath error:&error]) {
		GHFail(@"Deflate failed because %@",error);
	}
	[ASIHTTPRequest removeFileAtPath:filePath error:&error];
	
	task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/usr/bin/gzip"];
	[task setArguments:[NSArray arrayWithObjects:@"-d",gzippedFilePath,nil]];
	[task launch];
	[task waitUntilExit];
	
	inflatedString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
	
	success = ([inflatedString isEqualToString:originalString]);
	GHAssertTrue(success,@"deflate data is not the same as that generated by gzip");
	
}

@end
