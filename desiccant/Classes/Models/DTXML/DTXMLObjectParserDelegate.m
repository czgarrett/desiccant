//
//  DTXMLObjectParserDelegate.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLObjectParserDelegate.h"
#import "DTXMLObjectParserContext.h"

@interface DTXMLObjectParserDelegate()
//@property (nonatomic, retain) NSMutableDictionary *tempResult;
@property (nonatomic, retain) NSObject *result;
@property (nonatomic, retain) NSMutableArray *nestedParserDelegates;
@property (nonatomic, retain, readonly) DTXMLObjectParserContext *objectContext;
@end

@implementation DTXMLObjectParserDelegate
@synthesize result, nestedParserDelegates;

- (void)dealloc {
    [result release];
    [nestedParserDelegates release];
    
    [super dealloc];
}

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes nestedParserDelegates:(NSArray *)newNestedDelegates {
    if (self = [super initWithKey:newKey element:newElement matchingAttributes:newMatchingAttributes]) {
        self.nestedParserDelegates = [NSMutableArray arrayWithArray:newNestedDelegates];
//        for (DTXMLParserDelegate *nestedParserDelegate in nestedParserDelegates) {
//            nestedParserDelegate.parent = self;
//        }
    }
    return self;
}

+ (id)delegateWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes nestedParserDelegates:(NSArray *)newNestedDelegates {
	return [[[self alloc] initWithKey:newKey element:newElement matchingAttributes:newMatchingAttributes nestedParserDelegates:newNestedDelegates] autorelease];
}

+ (id)delegateWithElement:(NSString *)element nestedParserDelegates:(NSArray *)nestedDelegates {
    return [[[self alloc] initWithKey:element element:element matchingAttributes:nil nestedParserDelegates:nestedDelegates] autorelease];
}

// Subclasses should set the context property to a subclass of DTXMLParserContext, initialized with the specified parentContext.
// The subclass used should contain any state information used in parsing.  Storing state information in the context allows the 
// delegate to be reentrant, enabling self-referential and recursive delegates.
- (void)initContextWithParent:(DTXMLParserContext *)parentContext {
    self.context = [DTXMLObjectParserContext contextWithParent:parentContext delegate:self];
}

- (void)addNestedParserDelegate:(DTXMLParserDelegate *)newDelegate {
    [nestedParserDelegates addObject:newDelegate];
}

// Subclasses should call [super reset] and then do anything they need to do to set the parser into a state where it's ready
// to start parsing.
//- (void)reset {
//    [super reset];
//    self.tempResult = [NSMutableDictionary dictionaryWithCapacity:1];
//    for (DTXMLParserDelegate *delegate in nestedParserDelegates) {
//        [delegate reset];
//    }
//}

// Subclasses should implement this to handle the start of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will allocate
// temporary storage in a member variable.  Default implementation does nothing.  
- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict {
    self.objectContext.tempResult = [NSMutableDictionary dictionaryWithCapacity:8];
}

// Subclasses should implement this to handle the end of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will handle any final
// preparations necessary before returning its result.  Default implementation does nothing.  
- (void)handleEndForElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
              qualifiedName:(NSString *)qName {
    self.result = self.objectContext.tempResult;
}

// Subclasses should implement this method to return a DTXMLParser that can handle the specified element, or nil if 
// no appropriate parser exists.  Default implementation always returns nil.  
- (DTXMLParserDelegate *)delegateForNestedElement:(NSString *)elementName 
                                     namespaceURI:(NSString *)namespaceURI 
                                    qualifiedName:(NSString *)qualifiedName 
                                       attributes:(NSDictionary *)attributeDict {
    for (DTXMLParserDelegate *nestedParserDelegate in nestedParserDelegates) {
        if ([nestedParserDelegate canParseElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict]) {
            return nestedParserDelegate;
        }
        else {
        }
    }
    return nil;
}

// Subclasses that include nested parsers should implement this to store the result object returned from the nested parser into 
// whatever container object is being used.  Default implementation does nothing.  
- (void)collectResult:(NSObject *)collectedResult fromNestedDelegate:(DTXMLParserDelegate *)nestedDelegate {
    [self.objectContext.tempResult setObject:collectedResult forKey:nestedDelegate.key];
}

- (DTXMLObjectParserContext *)objectContext {
    return (DTXMLObjectParserContext *)context;
}

@end
