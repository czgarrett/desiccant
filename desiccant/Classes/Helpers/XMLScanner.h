//
//  XMLScanner.h
//  ZWorkbench
//
//  Created by Christopher Garrett on 11/7/08.
//  Copyright 2008 ZWorkbench, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 30200
@interface XMLScanner : NSXMLParser
#else
@interface XMLScanner : NSXMLParser <NSXMLParserDelegate> 
#endif
{
   NSString *desiredAttribute;
   NSString *desiredElement;
   NSString *scanResult;
}

- (NSString *) valueForElement: (NSString *)elementName attribute: (NSString *)attributeName;

@end
