//
//  DTXMLAttributeParserDelegate.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/1/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLAttributeParserDelegate.h"

@interface DTXMLAttributeParserDelegate()
@property (nonatomic, retain) NSObject *result;
@end


@implementation DTXMLAttributeParserDelegate
@synthesize attribute, result;

- (void)dealloc {
    self.attribute = nil;
    self.result = nil;
    
    [super dealloc];
}

- (id) initWithKey:(NSString *)newKey 
           element:(NSString *)newElement 
         attribute:(NSString *)newAttribute 
matchingAttributes:(NSDictionary *)newMatchingAttributes {
    if ((self = [super 
                initWithKey:newKey
                element:newElement
                matchingAttributes:newMatchingAttributes])) {
        self.attribute = newAttribute;
    }
    return self;
}

+ (DTXMLAttributeParserDelegate *) delegateWithKey:(NSString *)key 
                                           element:(NSString *)element 
                                         attribute:(NSString *)attribute 
                                matchingAttributes:(NSDictionary *)matchingAttributes {
    return [[[self alloc] initWithKey:key 
                              element:element 
                            attribute:attribute 
                   matchingAttributes:matchingAttributes] autorelease];
}

// Subclasses should implement this to handle the start of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will allocate
// temporary storage in a member variable.  Default implementation does nothing.  
- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict {
    self.result = [attributeDict objectForKey:attribute];
}


@end
