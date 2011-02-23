//
//  DTXMLParser.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLParserContext.h"

@class DTXMLParserContext;

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 30200
@interface DTXMLParserDelegate : NSObject
#else
@protocol NSXMLParserDelegate;
@interface DTXMLParserDelegate : NSObject <NSXMLParserDelegate>
#endif
{    
    NSString *key;
    NSString *element;
    NSDictionary *matchingAttributes;  
    DTXMLParserContext *context;
}

@property (nonatomic, copy, readonly) NSString *element;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, retain, readonly) NSDictionary *matchingAttributes;
@property (nonatomic, retain) DTXMLParserContext *context;

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes;
+ (DTXMLParserDelegate *)delegateWithElement:(NSString *)element;
+ (DTXMLParserDelegate *)delegateWithKey:(NSString *)key element:(NSString *)element;
+ (DTXMLParserDelegate *)delegateWithKey:(NSString *)key element:(NSString *)element matchingAttributes:(NSDictionary *)matchingAttributes;

// Subclasses should call [super reset] and then do anything they need to do to set the parser into a state where it's ready
// to start parsing.
//- (void)reset;

// Subclasses should set the context property to a subclass of DTXMLParserContext, initialized with the specified parentContext.
// The subclass used should contain any state information used in parsing.  Storing state information in the context allows the 
// delegate to be reentrant, enabling self-referential and recursive delegates.
- (void)initContextWithParent:(DTXMLParserContext *)parentContext;

// If the subclass has nested delegates it should set all their parents to self when this is called.  Default implementation does nothing.
//- (void)setParentOnNestedDelegates;

// Default implementation returns YES if elementName matches self.element.  Subclasses can override this if they
// want to enforce more stringent criteria for which elements they're willing to parse.  For example, a parser might only
// be willing to parse an element if a certain attribute matched a certain value.  If this parser manages a container, this
// method should return YES for the container element, not for its children.
- (BOOL)canParseElement:(NSString *)elementName 
           namespaceURI:(NSString *)namespaceURI 
          qualifiedName:(NSString *)qualifiedName
             attributes:(NSDictionary *)attributeDict;

// Subclasses should implement this to handle the start of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will allocate
// temporary storage in a member variable.  Default implementation does nothing.  
- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict;

// Subclasses should implement this to handle the end of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will handle any final
// preparations necessary before returning its result.  Default implementation does nothing.  
- (void)handleEndForElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
              qualifiedName:(NSString *)qName;

// Returns YES if parserForNestedElement:namespaceURI:qualifiedName:attributes: returns a non-nil value.
- (BOOL)hasDelegateForNestedElement:(NSString *)elementName 
                     namespaceURI:(NSString *)namespaceURI 
                    qualifiedName:(NSString *)qualifiedName 
                       attributes:(NSDictionary *)attributeDict;


// Subclasses should implement this method to return a DTXMLParser that can handle the specified element, or nil if 
// no appropriate parser exists.  Default implementation always returns nil.  
- (DTXMLParserDelegate *)delegateForNestedElement:(NSString *)elementName 
                           namespaceURI:(NSString *)namespaceURI 
                          qualifiedName:(NSString *)qualifiedName 
                             attributes:(NSDictionary *)attributeDict;

// Subclasses that include nested parsers should implement this to store the result object returned from the nested parser into 
// whatever container object is being used.  Default implementation does nothing.  
- (void)collectResult:(NSObject *)collectedResult fromNestedDelegate:(DTXMLParserDelegate *)nestedDelegate;

// After the end tag for the target element has been processesd, subclasses should be prepared to return an object containing 
// the parsed results when this method is called.  Default implementation returns nil.
- (NSObject *)result;

// If the result is a collection, subclasses should return the array for the collection.  Otherwise, rows should return a single 
// element array containing with the result object.  The default implementation returns an array wrapping the object returned by
// result.
- (NSMutableArray *)rows;

@end
