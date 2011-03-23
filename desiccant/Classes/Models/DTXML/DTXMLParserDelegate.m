//
//  DTXMLParser.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 7/6/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//
#import "DTXMLParserDelegate.h"
#import "Zest.h"

@interface DTXMLParserDelegate()
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *element;
@property (nonatomic, retain) NSDictionary *matchingAttributes;
- (BOOL)attributesMatch:(NSDictionary *)attributeDict;
@end


@implementation DTXMLParserDelegate
@synthesize key, element, matchingAttributes, context;

- (void)dealloc {
    [key release];
    [element release];
    [matchingAttributes release];
    [context release];
    
    [super dealloc];
}

- (id)initWithKey:(NSString *)newKey element:(NSString *)newElement matchingAttributes:(NSDictionary *)newMatchingAttributes {
    if ((self = [super init])) {
        self.key = newKey;
        self.element = newElement;
        self.matchingAttributes = newMatchingAttributes;
        
//        [self setParentOnNestedDelegates];
//        [self reset];
    }
    return self;
}

+ (DTXMLParserDelegate *)delegateWithKey:(NSString *)key element:(NSString *)element matchingAttributes:(NSDictionary *)matchingAttributes {
    return [[[self alloc] initWithKey:key element:element matchingAttributes:matchingAttributes] autorelease];
}

+ (DTXMLParserDelegate *)delegateWithKey:(NSString *)key element:(NSString *)element {
    return [[[self alloc] initWithKey:key element:element matchingAttributes:nil] autorelease];
}

+ (DTXMLParserDelegate *)delegateWithElement:(NSString *)element {
    return [[[self alloc] initWithKey:element element:element matchingAttributes:nil] autorelease];
}

- (void)reset {
    context.insideTargetElement = NO;
    context.targetElementDepth = -1;    
}

- (void)initContextWithParent:(DTXMLParserContext *)parentContext {
    self.context = [DTXMLParserContext contextWithParent:parentContext delegate:self];
}

- (void)restoreContext:(DTXMLParserContext *)contextToRestore {
    self.context = contextToRestore;
}

//- (void)setParentOnNestedDelegates {
//}

- (BOOL)canParseElement:(NSString *)elementName 
           namespaceURI:(NSString *)namespaceURI 
          qualifiedName:(NSString *)qualifiedName 
             attributes:(NSDictionary *)attributeDict {
    return [elementName isEqual:element] && [self attributesMatch:attributeDict];
}

- (BOOL)attributesMatch:(NSDictionary *)attributeDict {
    if (!matchingAttributes) return YES;
    for (NSString *attributeKey in [matchingAttributes allKeys]) {
        BOOL matchFound = NO;
        for (NSString *attributeValue in [matchingAttributes objectForKey:attributeKey]) {
            if ([attributeValue isEqual:[attributeDict stringForKey:attributeKey]]) {
                matchFound = YES;
                break;
            }
        }
        if (!matchFound) return NO;
    }
    return YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    if (!context.insideTargetElement) {
        if ([self canParseElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict]) {
            context.insideTargetElement = YES;
            context.targetElementDepth = context.parsingDepth;
            context.attributes = attributeDict;
            [self handleStartForElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
        }
        else {
        } // Ignore unparseable elements outside target
    }
    else {
        if ([self hasDelegateForNestedElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict]) {
            DTXMLParserDelegate *matchingDelegate = [self delegateForNestedElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            [matchingDelegate initContextWithParent:context];
            parser.delegate = matchingDelegate;
            [matchingDelegate parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
        }
        else {
        } // Ignore unparseable elements inside target
    }

    context.parsingDepth++;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {    
    context.parsingDepth--;
    
    if (context.insideTargetElement) {
        if (context.targetElementDepth == context.parsingDepth) {
            context.insideTargetElement = NO;
            [self handleEndForElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
        }
        else {
        }
    }
    else {
    }

    if (context.parsingDepth == 0) {
        if (context.parent) {
            [context.parent.delegate restoreContext:context.parent];
            [context.parent.delegate collectResult:[self result] fromNestedDelegate:self];
            [context.parent.delegate parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
            parser.delegate = context.parent.delegate;
        }
        else {
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DTLog(@">>> XML parsing error at line %d, column %d.", [parser lineNumber], [parser columnNumber]);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    DTLog(@">>> XML parsing error at line %d, column %d.", [parser lineNumber], [parser columnNumber]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}


- (NSObject *)result {
    return nil;
}

- (NSMutableArray *)rows {
    return [NSMutableArray arrayWithObject:[self result]];
}

- (void)collectResult:(NSObject *)collectedResult fromNestedDelegate:(DTXMLParserDelegate *)nestedDelegate {
}

- (void)handleStartForElement:(NSString *)elementName 
                 namespaceURI:(NSString *)namespaceURI 
                qualifiedName:(NSString *)qualifiedName 
                   attributes:(NSDictionary *)attributeDict {
}

- (void)handleEndForElement:(NSString *)elementName 
               namespaceURI:(NSString *)namespaceURI 
              qualifiedName:(NSString *)qName {
}

- (DTXMLParserDelegate *)delegateForNestedElement:(NSString *)elementName 
                           namespaceURI:(NSString *)namespaceURI 
                          qualifiedName:(NSString *)qualifiedName 
                             attributes:(NSDictionary *)attributeDict {
    return nil;
}

- (BOOL)hasDelegateForNestedElement:(NSString *)elementName 
                     namespaceURI:(NSString *)namespaceURI 
                    qualifiedName:(NSString *)qualifiedName 
                       attributes:(NSDictionary *)attributeDict {
    return nil != [self delegateForNestedElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}


@end
