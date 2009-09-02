//
//  DTXMLRPCQuery.m
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import "DTXMLParser.h"
#import "DTXMLRPCQuery.h"
#import "DTXMLValueParserDelegate.h"
#import "DTXMLObjectParserDelegate.h"
#import "DTXMLCollectionParserDelegate.h"
#import "Zest.h"

@interface NSObject(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSObject(xmlrpc)
- (NSString *)to_xmlrpc_value {
    return [NSString stringWithFormat:@"<value><string>%@</string></value>", [self description]];
}
@end

@interface NSString(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSString(xmlrpc)
- (NSString *)to_xmlrpc_value {
    return [NSString stringWithFormat:@"<value><string>%@</string></value>", self];
}
@end

@interface NSDictionary(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSDictionary(xmlrpc)
- (NSString *)to_xmlrpc_value {
    NSMutableString *string = [NSMutableString stringWithString:@"<value><struct>"];
    for (NSObject *key in [self allKeys]) {
        [string appendFormat:@"<member><name>%@</name>%@</member>", key, ((NSObject *)[self objectForKey:key]).to_xmlrpc_value];
    }
    [string appendString:@"</struct></value>"];
    return string;
}
@end

@interface NSNumber(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSNumber(xmlrpc)
- (NSString *)to_xmlrpc_value {
    switch (*[self objCType]) {
        case 'i':
            return [NSString stringWithFormat:@"<value><int>%@</int></value>", self];
        case 'c':
            return [NSString stringWithFormat:@"<value><boolean>%@</boolean></value>", self];
        default:
            return [NSString stringWithFormat:@"<value><int>%@</int></value>", self];
    }
}
@end

@interface NSArray(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSArray(xmlrpc)
- (NSString *)to_xmlrpc_value {
    NSMutableString *string = [NSMutableString stringWithString:@"<value><array><data>"];
    for (NSObject *value in self) {
        [string appendString:value.to_xmlrpc_value];
    }
    [string appendString:@"</data></array></value>"];
    return string;
}
@end

@interface NSData(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSData(xmlrpc)
- (NSString *)to_xmlrpc_value {
    return [NSString stringWithFormat:@"<value><base64>%@</base64></value>", [self base64EncodedString]];
}
@end

@interface NSDate(xmlrpc)
@property (nonatomic, retain, readonly) NSString *to_xmlrpc_value;
@end
@implementation NSDate(xmlrpc)
- (NSString *)to_xmlrpc_value {
    return [NSString stringWithFormat:@"<value><dateTime.iso8601>%@</dateTime.iso8601></value>", [self iso8601FormattedString]];
}
@end


@interface DTXMLRPCQuery()
- (NSData *)methodCallForName:(NSString *)methodName params:(NSArray *)params;
@property (nonatomic) NSInteger faultCode;
@property (nonatomic, retain) NSString *faultString;
@property (nonatomic, retain) NSString *valueType;
@property (nonatomic, retain) NSObject *response;
@property (nonatomic, retain) NSString *stringResponse;
@property (nonatomic, retain) NSNumber *numberResponse;
@property (nonatomic) BOOL boolResponse;
@property (nonatomic) NSInteger integerResponse;
@property (nonatomic) double doubleResponse;
@property (nonatomic, retain) NSDate *dateResponse;
@property (nonatomic, retain) NSData *dataResponse;
@property (nonatomic, retain) NSArray *arrayResponse;
@property (nonatomic, retain) NSDictionary *dictionaryResponse;
@end


@implementation DTXMLRPCQuery
@synthesize 
    faultCode, faultString, valueType, response, stringResponse, numberResponse, boolResponse, integerResponse, doubleResponse, 
    dateResponse, dataResponse, arrayResponse, dictionaryResponse;

- (void) dealloc {
    self.faultString = nil;
    self.valueType = nil;
    self.response = nil;
    self.stringResponse = nil;
    self.numberResponse = nil;
    self.dateResponse = nil;
    self.dataResponse = nil;
    self.arrayResponse = nil;
    self.dictionaryResponse = nil;
    
    [super dealloc];
}

+ (DTXMLRPCQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate methodName:(NSString *)methodName params:(NSArray *)params {
    return [[[self alloc] initWithURL:url delegate:delegate methodName:methodName params:(NSArray *)params] autorelease];
}

- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate methodName:(NSString *)newMethodName params:(NSArray *)newParams {
    DTXMLParserDelegate *intParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"int"];
    DTXMLParserDelegate *i4ParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"i4"];
    DTXMLParserDelegate *booleanParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"boolean"];
    DTXMLParserDelegate *stringParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"string"];
    DTXMLParserDelegate *doubleParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"double"];
    DTXMLParserDelegate *dateTimeParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"dateTime.iso8601"];
    DTXMLParserDelegate *base64ParserDelegate = [DTXMLValueParserDelegate delegateWithElement:@"base64"];
    DTXMLObjectParserDelegate *valueParserDelegate = [DTXMLObjectParserDelegate 
                                                      delegateWithElement:@"value" 
                                                      nestedParserDelegates:
                                                      [NSArray arrayWithObjects:
                                                       intParserDelegate,
                                                       i4ParserDelegate,
                                                       booleanParserDelegate,
                                                       stringParserDelegate,
                                                       doubleParserDelegate,
                                                       dateTimeParserDelegate,
                                                       base64ParserDelegate,
                                                       nil]];
    DTXMLCollectionParserDelegate *structParserDelegate = [DTXMLCollectionParserDelegate 
                                                           delegateWithElement:@"struct" 
                                                           nestedParserDelegate:[DTXMLObjectParserDelegate 
                                                                                 delegateWithElement:@"member" 
                                                                                 nestedParserDelegates:
                                                                                 [NSArray arrayWithObjects:
                                                                                  [DTXMLValueParserDelegate delegateWithElement:@"name"],
                                                                                  valueParserDelegate, nil]]];
    [valueParserDelegate addNestedParserDelegate:structParserDelegate];
    DTXMLCollectionParserDelegate *arrayParserDelegate = [DTXMLCollectionParserDelegate
                                                          delegateWithElement:@"array" 
                                                          nestedParserDelegate:valueParserDelegate];
    [valueParserDelegate addNestedParserDelegate:arrayParserDelegate];
    DTXMLObjectParserDelegate *faultParserDelegate = [DTXMLObjectParserDelegate
                                                          delegateWithElement:@"fault" 
                                                      nestedParserDelegates:[NSArray arrayWithObject:structParserDelegate]];
    DTXMLObjectParserDelegate *paramsParserDelegate = [DTXMLObjectParserDelegate
                                                         delegateWithElement:@"params" 
                                                         nestedParserDelegates:[NSArray arrayWithObject:valueParserDelegate]];
    DTXMLObjectParserDelegate *responseParserDelegate = [DTXMLObjectParserDelegate 
                                                             delegateWithElement:@"methodResponse" 
                                                             nestedParserDelegates:[NSArray arrayWithObjects:
                                                                                    faultParserDelegate,
                                                                                    paramsParserDelegate,
                                                                                    nil]];
    
    if (self = [super initWithURL:newURL delegate:newDelegate parser:[DTXMLParser parserWithParserDelegate:responseParserDelegate]]) {
        self.method = @"POST";
        self.body = [self methodCallForName:newMethodName params:newParams];
        [self addRowTransformer:self];
    }
    return self;
}

- (NSData *)methodCallForName:(NSString *)methodName params:(NSArray *)params {
    NSMutableString *bodyString = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\"?>\n<methodCall><methodName>%@</methodName><params>", methodName];
    for (NSObject *param in params) {
        [bodyString appendFormat:@"  <param>%@</param>\n", param.to_xmlrpc_value];
    }
    [bodyString appendFormat:@"</params></methodCall>"];
    const char *bytes = [bodyString UTF8String];
    return [NSData dataWithBytes:bytes length:strlen(bytes)];
}

- (void)clearResponseFields {
    self.valueType = nil;
    self.response = nil;
    self.stringResponse = nil;
    self.numberResponse = nil;
    self.boolResponse = NO;
    self.integerResponse = 0;
    self.doubleResponse = 0.0;
    self.dateResponse = nil;
    self.dataResponse = nil;
    self.arrayResponse = nil;
    self.dictionaryResponse = nil;
}

- (void)setResponseFields:(NSDictionary *)data {
    self.valueType = [data stringForKey:@"type"];
    self.response = [data objectForKey:@"value"];
    self.stringResponse = [data stringForKey:@"stringValue"];
    self.numberResponse = [data numberForKey:@"numberValue"];
    self.boolResponse = [[data numberForKey:@"numberValue"] boolValue];
    self.integerResponse = [[data numberForKey:@"numberValue"] integerValue];
    self.doubleResponse = [[data numberForKey:@"numberValue"] doubleValue];
    self.dateResponse = [data dateForKey:@"dateValue"];
    self.dataResponse = [data dataForKey:@"dataValue"];
    self.arrayResponse = [data arrayForKey:@"arrayValue"];
    self.dictionaryResponse = [data dictionaryForKey:@"dictionaryValue"];
}

- (NSString *)valueTypeFor:(NSDictionary *)value {
    return [[value allKeys] stringAtIndex:0];
}

- (NSString *)stringValue:(NSDictionary *)value {
    return [value stringForKey:[self valueTypeFor:value]];
}

- (NSNumber *)numberValue:(NSDictionary *)value {
    NSNumber *number = nil;
    if ([[NSArray arrayWithObjects:@"i4", @"int", @"boolean", @"double", nil] containsObject:[self valueTypeFor:value]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        number = [formatter numberFromString:[self stringValue:value]];
        [formatter release];
    }
    return number;
}

- (NSDate *)dateValue:(NSDictionary *)value {
    if ([[self valueTypeFor:value] isEqual:@"dateTime.iso8601"]) {
        return [NSDate dateWithISO8601String:[self stringValue:value]];
    }
    else {
        return nil;
    }
}

- (NSData *)dataValue:(NSDictionary *)value {
    if ([[self valueTypeFor:value] isEqual:@"base64"]) {
        return [NSData dataFromBase64String:[self stringValue:value]];
    }
    else {
        return nil;
    }
}

- (NSObject *)objectValue:(NSDictionary *)value {
    if ([[self valueTypeFor:value] isEqual:@"int"] || 
        [[self valueTypeFor:value] isEqual:@"i4"] ||
        [[self valueTypeFor:value] isEqual:@"double"]) {
        return [self numberValue:value];
    }
    else if ([[self valueTypeFor:value] isEqual:@"boolean"]) {
        if ([[self numberValue:value] intValue] == 0) {
            return [NSNumber numberWithBool:NO];
        }
        else {
            return [NSNumber numberWithBool:YES];
        }
    }
    else if ([[self valueTypeFor:value] isEqual:@"dateTime.iso8601"]) {
        return [self dateValue:value];
    }
    else if ([[self valueTypeFor:value] isEqual:@"base64"]) {
        return [self dataValue:value];
    }
    else {
        return [self stringValue:value];
    }
}

- (NSDictionary *)dictionaryValue:(NSDictionary *)value {
    NSMutableDictionary *dictionary = nil;
    if ([[self valueTypeFor:value] isEqual:@"struct"]) {
        dictionary = [NSMutableDictionary dictionary]; 
        for (NSDictionary *member in [value arrayForKey:@"struct"]) {
            [dictionary setValue:[self objectValue:[member dictionaryForKey:@"value"]] forKey:[member stringForKey:@"name"]];
        }
    }
    return dictionary;
}

- (NSArray *)arrayValue:(NSDictionary *)value {
    NSMutableArray *array = nil;
    if ([[self valueTypeFor:value] isEqual:@"array"]) {
        array = [NSMutableArray array];
        NSArray *valueArray = [value arrayForKey:@"array"];
        for (NSDictionary *element in valueArray) {
            [array addObject:[self objectValue:element]];
        }
    }
    return array;
}

- (void)transform:(NSMutableDictionary *)data {
    [self clearResponseFields];
    if ([data objectForKey:@"params"]) {
        [data setValue:nil forKey:@"faultCode"];
        [data setValue:nil forKey:@"faultString"];
        NSDictionary *value = [[data dictionaryForKey:@"params"] dictionaryForKey:@"value"];
        [data setValue:[self valueTypeFor:value] forKey:@"type"];
        [data setValue:[self objectValue:value] forKey:@"value"];
        [data setValue:[self stringValue:value] forKey:@"stringValue"];
        [data setValue:[self numberValue:value] forKey:@"numberValue"];
        [data setValue:[self dateValue:value] forKey:@"dateValue"];
        [data setValue:[self dataValue:value] forKey:@"dataValue"];
        [data setValue:[self dictionaryValue:value] forKey:@"dictionaryValue"];
        [data setValue:[self arrayValue:value] forKey:@"arrayValue"];
        [self setResponseFields:data];
    }
    else if ([data objectForKey:@"fault"]) {
        NSLog(@"*** Fault returned for query:\n\n%s", self.body);
        for (NSDictionary *member in [[data dictionaryForKey:@"fault"] arrayForKey:@"struct"]) {
            if ([[member stringForKey:@"name"] isEqual:@"faultCode"]) {
                [data setValue:[[member dictionaryForKey:@"value"] stringForKey:@"int"] forKey:@"faultCode"];
                self.faultCode = [data stringForKey:@"faultCode"].to_i;
            }
            else if ([[member stringForKey:@"name"] isEqual:@"faultString"]) {
                [data setValue:[[member dictionaryForKey:@"value"] stringForKey:@"string"] forKey:@"faultString"];
                self.faultString = [data stringForKey:@"faultString"];
            }
            else {
                [data setValue:@"Unexpected member in fault response." forKey:@"faultString"];
                self.faultString = [data stringForKey:@"faultString"];
            }
        }
    }
}

@end
