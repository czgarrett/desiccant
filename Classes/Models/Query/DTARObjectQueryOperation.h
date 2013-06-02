////
////  DTARObjectQueryOperation.h
////
////  Created by Curtis Duhn on 12/4/09.
////  Copyright 2009 ZWorkbench. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "DTAsyncQueryOperationDelegate.h"
//#import "ARObject.h"
//
//@interface DTARObjectQueryOperation : DTAsyncQueryOperation {
//	Class arObjectClass;
//	NSMutableArray *rows;
//	NSString *error;
//}
//
//@property (nonatomic, retain) Class arObjectClass;
//@property (nonatomic, retain) NSMutableArray *rows;
//@property (nonatomic, retain) NSString *error;
//
//- (id)initWithClass:(Class)theARObjectClass delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate;
//+ (id)operationWithClass:(Class)arObjectClass delegate:(NSObject <DTAsyncQueryOperationDelegate> *)newDelegate;
//
//// Returns the result of findAll by default.  Subclasses may override this to return a subset.
//- (NSArray *)findModelObjects;
//// Returns the raw attributes dictionary by default.  Subclasses may override this to return a custom dictionary.
//- (NSDictionary *)dictionaryForModel:(ARObject *)model;
//
//@end
