//
//  XMLScanner.m
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import "XMLScanner.h"


@implementation XMLScanner

- (NSString *) valueForElement: (NSString *)elementName attribute: (NSString *)attributeName {
   desiredAttribute = attributeName;
   desiredElement = elementName;
   scanResult = nil;
   [self setDelegate: self];
   [self parse];
   return scanResult;
}

- (void)          parser:(NSXMLParser *)parser 
         didStartElement:(NSString *)elementName 
            namespaceURI:(NSString *)namespaceURI 
           qualifiedName:(NSString *)qualifiedName 
              attributes:(NSDictionary *)attributeDict {
   
   if ([elementName isEqualToString: desiredElement]) {
      NSString *attributeValue = (NSString *) [attributeDict objectForKey: desiredAttribute];
      if (attributeValue) {
         scanResult = attributeValue;
         [self abortParsing];
      }
   }   
}

@end
