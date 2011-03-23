//
//  DTXMLCollectionParser.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLCollectionParserDelegate.h"
#import "DTXMLCollectionParserContext.h"

// *** Note: This implementation is currently not reentrant.  This means you can't have a nested parser that nests itself
// recursively.  If you try this, spooky errors will arise.  So don't try using this framework to parse recursive schemas.


@interface DTXMLCollectionParserDelegate()
@property (nonatomic, retain) NSObject *result;
@property (nonatomic, retain) DTXMLParserDelegate *nestedParserDelegate;
@property (nonatomic, retain, readonly) DTXMLCollectionParserContext *collectionContext;
@end

@implementation DTXMLCollectionParserDelegate
@synthesize result, nestedParserDelegate;

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes
 nestedParserDelegate:(DTXMLParserDelegate *)newNestedParserDelegate {
    if ((self = [super initWithKey:newKey element:newElement matchingAttributes:newMatchingAttributes])) {
        self.nestedParserDelegate = newNestedParserDelegate;
//        nestedParserDelegate.parent = self;
    }
    return self;
}

+ (id)delegateWithKey:(NSString *)newKey 
			  element:(NSString *)newElement 
   matchingAttributes:(NSDictionary *)newMatchingAttributes
 nestedParserDelegate:(DTXMLParserDelegate *)newNestedParserDelegate {
    return [[[self alloc] initWithKey:newKey element:newElement matchingAttributes:newMatchingAttributes nestedParserDelegate:newNestedParserDelegate] autorelease];
}

+ (id)delegateWithElement:(NSString *)element 
                                  nestedParserDelegate:(DTXMLParserDelegate *)nestedParserDelegate {
    return [[[self alloc] initWithKey:element element:element matchingAttributes:nil nestedParserDelegate:nestedParserDelegate] autorelease];
}

// Subclasses should set the context property to a subclass of DTXMLParserContext, initialized with the specified parentContext.
// The subclass used should contain any state information used in parsing.  Storing state information in the context allows the 
// delegate to be reentrant, enabling self-referential and recursive delegates.
- (void)initContextWithParent:(DTXMLParserContext *)parentContext {
    self.context = [DTXMLCollectionParserContext contextWithParent:parentContext delegate:self];
}

// Subclasses should call [super reset] and then do anything they need to do to set the parser into a state where it's ready
// to start parsing.
//- (void)reset {
//    [super reset];
//    self.tempResults = [NSMutableArray array];
//    self.rows = [NSMutableArray array];
//    [nestedParserDelegate reset];
//}

// Subclasses should implement this to handle the start of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will allocate
// temporary storage in a member variable.  Default implementation does nothing.  
- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict {
    self.collectionContext.tempResults = [NSMutableArray array];
}

// Subclasses should implement this to handle the end of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will handle any final
// preparations necessary before returning its result.  Default implementation does nothing.  
- (void)handleEndForElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
              qualifiedName:(NSString *)qName {
    self.result = self.collectionContext.tempResults;
}

// Subclasses should implement this method to return a DTXMLParser that can handle the specified element, or nil if 
// no appropriate parser exists.  Default implementation always returns nil.  
- (DTXMLParserDelegate *)delegateForNestedElement:(NSString *)elementName 
                           namespaceURI:(NSString *)namespaceURI 
                          qualifiedName:(NSString *)qualifiedName 
                             attributes:(NSDictionary *)attributeDict {
    if ([nestedParserDelegate canParseElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict]) {
        return nestedParserDelegate;
    }
    else {
        return nil;
    }
}

// Subclasses that include nested parsers should implement this to store the result object returned from the nested parser into 
// whatever container object is being used.  Default implementation does nothing.  
- (void)collectResult:(NSObject *)collectedResult fromNestedDelegate:(DTXMLParserDelegate *)nestedDelegate {
    [self.collectionContext.tempResults addObject:collectedResult];
}

- (NSMutableArray *)rows {
    return self.collectionContext.tempResults;
}
- (DTXMLCollectionParserContext *)collectionContext {
    return (DTXMLCollectionParserContext *)context;
}


@end
