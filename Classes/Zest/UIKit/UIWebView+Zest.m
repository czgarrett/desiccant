//
//  UIWebView+Zest.m
//  ProLog
//
//  Created by Christopher Garrett on 2/3/10.
//  Copyright 2010 ZWorkbench, Inc.. All rights reserved.
//

#import "UIWebView+Zest.h"
#import "Zest.h"

@implementation UIWebView(Zest)

- (void) loadHTMLResourceNamed: (NSString *) htmlResourceName {
   NSBundle *mainBundle = [NSBundle mainBundle];
   NSStringEncoding encoding;
   NSError *error = nil;
   NSString *fileContents = [NSString stringWithContentsOfFile: [mainBundle pathForResource: htmlResourceName ofType: @"html"] usedEncoding:&encoding error:&error];
   if (error) {
      DTLog(@"Error reading file: %@", [error localizedDescription]);
   } else {
      [self loadHTMLString: fileContents baseURL:[NSURL fileURLWithPath:[mainBundle resourcePath]]];         
   } 
}


@end
