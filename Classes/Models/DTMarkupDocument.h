//
//  DTMarkupDocument.h
//  PortablePTO
//
//  Created by Curtis Duhn on 2/3/10.
//  Copyright 2010 ZWorkbench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTMarkupDocument : NSObject {
	NSData *data;
	NSString *namespaceURI;
	NSString *namespacePrefix;
}

- (id)initWithData:(NSData *)theData;
+ (id)documentWithData:(NSData *)theData;
// Performs an XPath Query on the document.  Returns an array of nodes, where each node is a dictionary with the
// following entries:
//  * nodeName — an NSString containing the name of the node
//  * nodeContent — an NSString containing the textual content of the node
//  * nodeAttributeArray — an NSArray of NSDictionary where each dictionary has two keys: attributeName (NSString) and nodeContent (NSString)
//  * nodeChildArray — an NSArray of child nodes (same structure as this node)
- (NSArray *)findHTMLNodes:(NSString *)xpath;
- (NSArray *)findXMLNodes:(NSString *)xpath;

@property (nonatomic, retain, readonly) NSData *data;
@property (nonatomic, retain, readonly) NSString *namespaceURI;
@property (nonatomic, retain, readonly) NSString *namespacePrefix;

@end
