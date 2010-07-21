//
//  XMLScanner.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XMLScanner : NSXMLParser <NSXMLParserDelegate> {
   NSString *desiredAttribute;
   NSString *desiredElement;
   NSString *scanResult;
}

- (NSString *) valueForElement: (NSString *)elementName attribute: (NSString *)attributeName;

@end
