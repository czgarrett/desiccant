//
//  DTXMLRPCQuery.h
//  ZWorkbench
//
//  Created by Curtis Duhn on 8/5/09.
//  Copyright 2009 ZWorkbench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTXMLHTTPQuery.h"

@interface DTXMLRPCQuery : DTXMLHTTPQuery <DTTransformsUntypedData> {
    NSInteger faultCode;
    NSString *faultString;
    NSString *valueType;
    NSObject *response;
    NSString *stringResponse;
    NSNumber *numberResponse;
    BOOL boolResponse;
    NSInteger integerResponse;
    double doubleResponse;
    NSDate *dateResponse;
    NSData *dataResponse;
    NSArray *arrayResponse;
    NSDictionary *dictionaryResponse;
}

@property (nonatomic, readonly) NSInteger faultCode;
@property (nonatomic, retain, readonly) NSString *faultString;
@property (nonatomic, retain, readonly) NSString *valueType;
@property (nonatomic, retain, readonly) NSObject *response;
@property (nonatomic, retain, readonly) NSString *stringResponse;
@property (nonatomic, retain, readonly) NSNumber *numberResponse;
@property (nonatomic, readonly) BOOL boolResponse;
@property (nonatomic, readonly) NSInteger integerResponse;
@property (nonatomic, readonly) double doubleResponse;
@property (nonatomic, retain, readonly) NSDate *dateResponse;
@property (nonatomic, retain, readonly) NSData *dataResponse;
@property (nonatomic, retain, readonly) NSArray *arrayResponse;
@property (nonatomic, retain, readonly) NSDictionary *dictionaryResponse;

+ (DTXMLRPCQuery *)queryWithURL:(NSURL *)url delegate:(NSObject <DTAsyncQueryDelegate> *)delegate methodName:(NSString *)methodName params:(NSArray *)params;
- (id)initWithURL:(NSURL *)newURL delegate:(NSObject <DTAsyncQueryDelegate> *)newDelegate methodName:(NSString *)newMethodName params:(NSArray *)newParams;

@end
