//
//  DTXMLValueParser.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLValueParserDelegate.h"
#import "DTXMLValueParserContext.h"

@interface DTXMLValueParserDelegate()
//@property (nonatomic, retain) NSMutableString *tempValue;
@property (nonatomic, retain) NSObject *result;
@property (nonatomic, retain, readonly) DTXMLValueParserContext *valueContext;
@end


@implementation DTXMLValueParserDelegate
@synthesize result;

- (void)dealloc {
//    [tempValue release];
    self.result = nil;
    
    [super dealloc];
}

// Subclasses should set the context property to a subclass of DTXMLParserContext, initialized with the specified parentContext.
// The subclass used should contain any state information used in parsing.  Storing state information in the context allows the 
// delegate to be reentrant, enabling self-referential and recursive delegates.
- (void)initContextWithParent:(DTXMLParserContext *)parentContext {
    self.context = [DTXMLValueParserContext contextWithParent:parentContext delegate:self];
}

// Subclasses should call [super reset] and then do anything they need to do to set the parser into a state where it's ready
// to start parsing.
//- (void)reset {
//    [super reset];
//    self.tempValue = [NSMutableString string];
//}

// Subclasses should implement this to handle the start of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will allocate
// temporary storage in a member variable.  Default implementation does nothing.  
- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict {
    self.valueContext.tempValue = [NSMutableString stringWithCapacity:16];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string) {
        [self.valueContext.tempValue appendString:string];
    }
}

// Subclasses should implement this to handle the end of any element for which 
// canParseElement:namespaceURI:qualifiedName:attributes: returns YES.  Typically this implementation will handle any final
// preparations necessary before returning its result.  Default implementation does nothing.  
- (void)handleEndForElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
              qualifiedName:(NSString *)qName {
    self.result = self.valueContext.tempValue;
//    NSLog(@"Found Value: %@ for %@", tempValue, elementName);
}

- (DTXMLValueParserContext *)valueContext {
    return (DTXMLValueParserContext *)context;
}

@end
